defmodule ConaWeb.ErrorJSONTest do
  use ConaWeb.ConnCase, async: true

  test "renders 404" do
    assert ConaWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ConaWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
