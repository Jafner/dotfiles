{pkgs, ...}: {
  specialisation.experimental-optimization.configuration = {
    boot.kernelParams = [
      "nowatchdog"
      "nohz=on"
      "mitigations=off"
      "threadirqs"
      "udev.log_priority=3"
      "preempt=full"
    ];
  };
}
