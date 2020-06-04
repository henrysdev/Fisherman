defmodule FishermanServerWeb.PidColumnComponentTest do
  use FishermanServerWeb.ConnCase

  alias FishermanServerWeb.Live.ShellRecordsTable.PidColumnComponent

  @records [
    %FishermanServer.ShellRecord{
      command: "ssh -N -L abc.com user.last@abc",
      command_timestamp: ~U[2020-05-28 08:28:12.035000Z],
      error: "zsh: command not found: asd",
      error_timestamp: ~U[2020-05-28 08:28:12.095000Z],
      inserted_at: ~N[2020-05-28 08:28:12],
      pid: "72508",
      updated_at: ~N[2020-05-28 08:28:12],
      user_id: "453cecfe-d768-47fa-8f0b-0e42b179c612",
      uuid: "6b88399c-361b-4fc5-bdbd-3c56e7c3d889"
    },
    %FishermanServer.ShellRecord{
      command: "asdf",
      command_timestamp: ~U[2020-05-27 23:00:40.076000Z],
      error: "zsh: command not found: asdf",
      error_timestamp: ~U[2020-05-27 23:00:40.125000Z],
      inserted_at: ~N[2020-05-27 23:00:40],
      pid: "41159",
      updated_at: ~N[2020-05-27 23:00:40],
      user_id: "a261435a-34b4-4135-ab9f-cfea41eb59ed",
      uuid: "4506cfd5-cf13-4d08-a526-d72f52ac6749"
    }
  ]
  @row_info %{
    num_rows: 10,
    row_height: 3.5,
    pid_col_width: 20.0,
    time_incr: 1000,
    first_ts: 1_590_654_490_035,
    time_axis_width: 12
  }

  test "renders as expected" do
    rendered =
      PidColumnComponent.render(%{
        records: @records,
        row_info: @row_info
      })

    assert rendered.static == ["<div class=\"swimlanes__column\">\n\n  ", "\n\n</div>\n"]
  end

  test "calculates y_offset" do
    [record | _] = @records
    actual_y_offset = PidColumnComponent.calc_y_offset(record, @row_info)

    assert actual_y_offset == 3.5
  end
end
