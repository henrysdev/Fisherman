package application

import (
	"github.com/pkg/errors"

	httpclient "github.com/henrysdev/fisherman/fishermand/pkg/http_client"
	messageapid "github.com/henrysdev/fisherman/fishermand/pkg/message_apid"
)

// FishermanAPI for interacting with Fisherman. This is the top level API for the client.
type FishermanAPI interface {
	Start() error
}

// Fisherman contains necessary data for top level API methods
type Fisherman struct {
	Config     *Config
	Consumer   messageapid.ConsumerAPI
	Dispatcher httpclient.DispatchAPI
}

// NewFisherman returns a new instance of Fisherman
func NewFisherman(cfg *Config) *Fisherman {
	buffer := messageapid.NewBuffer()
	dispatcher := httpclient.NewDispatcher()
	handler := messageapid.NewMessageHandler()
	consumer := messageapid.NewConsumer(
		cfg.FifoPipe,
		buffer,
		dispatcher,
		cfg.UpdateFrequency,
		cfg.MaxCmdsPerUpdate,
		handler,
	)
	return &Fisherman{
		Config:     cfg,
		Consumer:   consumer,
		Dispatcher: dispatcher,
	}
}

// Start should be called immediately after instantiation
func (f *Fisherman) Start() error {

	// Setup command consumer
	if err := f.Consumer.Setup(); err != nil {
		return errors.Wrap(err, "Fisherman failed to setup Consumer")
	}

	errorChan := make(chan error)
	defer close(errorChan)

	// Spawn consumer to listen for messages
	go f.Consumer.Listen(errorChan)

	return <-errorChan
}
