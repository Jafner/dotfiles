{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ffmpeg];

      jdks = [
        jdk21
        jdk17
        jdk8
        javaPackages.compiler.temurin-bin.jre-17
      ];
    })
  ];
}
