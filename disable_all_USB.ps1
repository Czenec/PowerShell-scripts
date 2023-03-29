# This is a troll script that opens a rickroll then disables all USBs on the PC
# This would be fun to use on a desktop PC at logon however sadly the Pnp device doesn't update untill startup so it doesn't really work.

Start-Process "https://youtu.be/dQw4w9WgXcQ"

Get-PnpDevice -Class USB | Disable-PnpDevice -Confirm:$false