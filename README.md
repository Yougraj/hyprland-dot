# Hyprland



![Screenshot](https://github.com/Yougraj/hyprland-dot/blob/main/main.png?raw=true)

## install

### yay

```
# Before this you need base-devel installed
git clone https://aur.archlinux.org/yay-bin
cd yay-bin
makepkg -si
```


### Required Packages

```bash
yay -S hyprland-bin polkit-gnome ffmpeg neovim viewnior       \
rofi pavucontrol thunar starship wl-clipboard wf-recorder     \
swaybg grimblast-git ffmpegthumbnailer tumbler playerctl      \
noise-suppression-for-voice thunar-archive-plugin kitty       \
waybar-hyprland wlogout swaylock-effects sddm-git pamixer     \
nwg-look-bin nordic-theme papirus-icon-theme dunst otf-sora   \
ttf-nerd-fonts-symbols-common otf-firamono-nerd inter-font    \
ttf-fantasque-nerd noto-fonts noto-fonts-emoji ttf-comfortaa  \
ttf-jetbrains-mono-nerd ttf-icomoon-feather ttf-iosevka-nerd  \
adobe-source-code-pro-fonts xdg-desktop-portal-wlr
```

### If filemanager not showing any external hardisk
```bash
yay -S polkit 
```
### If mobile devices not showing in filemanager

```bash
yay -S gvfs-mtp gvfs-afc
```



## Sources used making these

- Official Hyprland Github <https://github.com/hyprwm/Hyprland>
- Chris Titus Hyprland dot files <https://github.com/ChrisTitusTech/hyprland-titus/>