use Mix.Config

config :scrap_hub, :viewport, %{
  name: :main_viewport,
  # default_scene: {ScrapHub.Scene.Crosshair, nil},
  # default_scene: {ScrapHub.Scene.SysInfo, nil},
  default_scene: {ScrapHub.Scene.Weather, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :scrap_hub"]
    }
  ]
}
