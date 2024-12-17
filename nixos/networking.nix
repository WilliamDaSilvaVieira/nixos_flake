{ ... }:
{
  networking = {
    hostName = "william";
    networkmanager.enable = true;
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    firewall = {
      allowedTCPPorts = [
        5900
      ];
      allowedUDPPorts = [
        5900
      ];
    };
  };
}
