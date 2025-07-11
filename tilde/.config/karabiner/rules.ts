import fs from 'fs'
import { KarabinerRules } from './types'
import { createHyperSubLayers, app, open } from './utils'

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: 'Hyper Key (⌃⌥⇧⌘)',
    manipulators: [
      {
        description: 'Caps Lock -> Hyper Key',
        from: {
          key_code: 'caps_lock',
          modifiers: {
            optional: ['any'],
          },
        },
        to: [
          {
            set_variable: {
              name: 'hyper',
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: 'hyper',
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: 'escape',
          },
        ],
        type: 'basic',
      },
    ],
  },
  ...createHyperSubLayers({
    f: app('Finder'),
    h: open('raycast://extensions/raycast/clipboard-history/clipboard-history'),
    b: open('raycast://extensions/Codely/google-chrome/search-bookmarks'),
    e: open('raycast://extensions/raycast/emoji-symbols/search-emoji-symbols'),
    c: open('raycast://extensions/thomas/color-picker/pick-color'),
    d: open('raycast://extensions/djpowers/devdocs/search-docsets'),
  }),
]

fs.writeFileSync(
  'karabiner.json',
  JSON.stringify(
    {
      global: {
        ask_for_confirmation_before_quitting: true,
        check_for_updates_on_startup: true,
        show_in_menu_bar: true,
        show_profile_name_in_menu_bar: false,
        unsafe_ui: false,
      },
      profiles: [
        {
          name: 'Default',
          virtual_hid_keyboard: { keyboard_type_v2: 'ansi' },
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2
  )
)
