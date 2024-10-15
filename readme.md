# Action for [ideckia](https://ideckia.github.io/): spotube-control

## Description


Action to control [Spotube](https://github.com/KRTirtho/spotube) music player. First of all you have to enable API in the Nuclear player itself.

`Settings->Enable Connect`

The items icons are customizable. Just put the images in the `[ideckia_dir]/actions/spotube-control/img` directory. These are the images that this action looks for:

* spotube_logo.png
* previous.png
* next.png
* play.png
* pause.png

## Properties

No properties needed

## On single click

Opens a basic control-panel with the album cover, play-pause, next, previous buttons

## On long press

Force to reconnect to Spotube

## Localizations

The localizations are stored in `loc` directory. A JSON for each locale.

## Test the action

There is a script called `test_action.js` to test the new action. Set the `props` variable in the script with the properties you want and run this command:

```
node test_action.js
```

## Example in layout file

```json
{
    "text": "spotube-control example",
    "bgColor": "00ff00",
    "actions": [
        {
            "name": "spotube-control",
            "props": {}
        }
    ]
}
```
