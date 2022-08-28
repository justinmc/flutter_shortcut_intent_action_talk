# Custom User Interactions - Flutter Vikings 2022

A live demo for the Flutter Vikings 2022 talk - Custom User Interactions with Shortcuts, Intents, and Actions ([slides](https://docs.google.com/presentation/d/1hUsKF8Vly72-Phcn7L9ikjJlFYFLUirNt1oGWu_BBSU/edit#slide=id.g147a725c12b_0_20)).

## Main demo: [Flutter Paint](https://github.com/justinmc/flutter_shortcut_intent_action_talk/tree/main/lib/paint_page)

A simplified drawing app.  Demonstrates [Actions](https://master-api.flutter.dev/flutter/widgets/Actions-class.html) and [Shortcuts](https://master-api.flutter.dev/flutter/widgets/Shortcuts-class.html) in a real app, as well as text editing shortcuts with [DefaultTextEditingShortcuts](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/default_text_editing_shortcuts.dart).

Use the dropdown in the AppBar to switch between code versions mentioned in the talk.

## Other demos

  1. [Actions demo](https://github.com/justinmc/flutter_shortcut_intent_action_talk/tree/main/lib/actions_page) - demonstrates Actions and Actions.invoke.
  1. [Shortcuts demo](https://github.com/justinmc/flutter_shortcut_intent_action_talk/tree/main/lib/shortcuts_page) - demonstrates Shortcuts and Actions together.
  1. [TextField demo](https://github.com/justinmc/flutter_shortcut_intent_action_talk/tree/main/lib/text_field_page) - demonstrates how Flutter manages keyboard shortcuts internally and how app developers can customize the default behavior.

## Quiz questions

  1. [Actions nested](https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_actions_nested.dart)
  1. [Actions nested with one empty](https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_actions_nested_empty.dart)
  1. [Shortcuts nested](https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_shortcuts_nested.dart)
  1. [Actions above and below Shortcuts](https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_shortcuts_sandwiched.dart)
  1. [TextField override](https://github.com/justinmc/flutter_shortcut_intent_action_talk/blob/main/lib/quiz_page/quiz_page_text_field.dart)

### Repository maintenance
To publish to GitHub Pages, do the following:

  1. `git checkout pages`
  1. `flutter build web`
  1. Edit build/web/index.html and change the `base` `href` to `"flutter_shortcut_intent_action_talk/".
  1. `cp -r build/web/ docs/`
  1. `git commit -am "Update GitHub Pages"`
  1. `git push`
