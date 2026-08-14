#!/usr/bin/env bash
set -euo pipefail

# Инициализация ключей pacman и обновление базы
pacman-key --init
pacman-key --populate archlinux
pacman -Syu --noconfirm archiso

# Копирование официального эталонного профиля releng
cp -r /usr/share/archiso/configs/releng /tmp/profile

# Добавление KDE Plasma и нужного софта в список пакетов
cat << 'PKGS' >> /tmp/profile/packages.x86_64
plasma-desktop
sddm
konsole
dolphin
plasma-nm
kinfocenter
pipewire
pipewire-pulse
pipewire-alsa
wireplumber
fastfetch
git
vim
nano
PKGS

# Включение автозапуска дисплей-менеджера SDDM
ln -sf /usr/lib/systemd/system/sddm.service /tmp/profile/airootfs/etc/systemd/system/display-manager.service

# Запуск сборки ISO
mkarchiso -v -w /tmp/archiso-tmp -o /workspace/out /tmp/profile
