{ lib
, stdenv
, fetchFromGitHub
, cairo
, fennel
, glib
, libdrm
, libinput
, libxcb
, libxkbcommon
, libxml2
, lua
, meson
, ninja
, pango
, pkg-config
, scdoc
, wayland
, wayland-protocols
, wlroots_0_15
, xwayland
}:

stdenv.mkDerivation rec {
  pname = "labwc";
  version = "0.5.0";

  src = ./.;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    cairo
    fennel
    glib
    libdrm
    libinput
    libxcb
    libxkbcommon
    libxml2
    lua
    pango
    wayland
    wayland-protocols
    wlroots_0_15
    xwayland
  ];

  LUA_PATH = "${fennel}/share/lua/5.4.3/?.lua";

  mesonFlags = [ "-Dxwayland=enabled" ];

  meta = with lib; {
    homepage = "https://github.com/labwc/labwc";
    description = "A Wayland stacking compositor, similar to Openbox";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
}