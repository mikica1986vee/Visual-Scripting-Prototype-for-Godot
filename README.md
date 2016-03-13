#Visual Scripting Prototype for Godot

Work in progress, backward compatibility is not guaranteed. Suggestions are welcome. :)

##Basic overview

Actions are played in response to events. You can use Prop object to see how to implement them in your custom objects or you can use signals.

If action is played it will check if it's conditions (immediate children only, by design) are fulfilled and if they are it will do it's effects (immediate children only, by design). There are different types of actions (Action being the only one implemented at the moment) in line with IfElseAction, DelegateAction, VariableAction, etc...

Effect change states of other objects, for example FadeToEffect will change alpha of some object.

<b>Connecting signal to action.</b> Connect signal to action, then be sure to turn off 'generate method' and call 'play_action' method.

###Important note

If you try to connect some elements inside editor and they refuse to show up, you are not connecting the right type of object or your object does not have required methods. If you are sure your custom object has required methods, make it a tool script (because of reasons that will be fixed during development :P ). 

##How to integrate into your project

You only need to place Visual-Scripting-Prototype-for-Godot in your addons directory and enable it in project settings (newly added plugins tab). I suggest you rename it to something less insane or symlink it. 

After activating plugin, click on add node (or CTRL + A) and you'll see some new nodes without icons.

At the moment, Monitors are not loaded automatically and there is no icons. 

Use <b>Custom<i>Something</i></b> for your own actions, effects and conditions.

##Extending stuff

Check out Examples directory. Inside you will find 'ExampleEffect.gd'. Follow directions and it should work.
At the moment whatever you make must extend from existing script (effect, action, condition) or Node. Otherwise it will not work with add node dialog.

##Misc info

Visual scripting system focused on productivity and ease of use. Also known as SVS (Simple Visual Scripting, courtesy of bojidar_bg :D ).

