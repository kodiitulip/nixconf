{
  flake.nixosModules.obs-studio =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          waveform
          obs-websocket
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vkcapture
          obs-tuna
        ];
        enableVirtualCamera = true;
      };

      persistance.user.directories = [
        ".config/obs-studio"
      ];
    };
}
