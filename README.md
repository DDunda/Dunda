# DundaFigura
This is my custom model for Minecraft using the Figura mod.

## Script
It has an extensive script for a high amount of personality and situational awareness, including:
 * A dynamic tail that reacts to motion, crouching, and riding vehicles:
   * Different wagging speeds
   * Different wagging amounts
   * The angle of the tail (in three segments)
 * A face with eyebrows, eyes, glowing eyes, face lines, and blush which can each be individually assigned for many expressions:
   * Sleeping
   * Damage/Death
   * Squinting underwater
   * Blindness (eyes are closed)
   * Night vision (eyes glow in the dark)
   * 'Hero of the village' (blushing)
   * Surprise:
     * While falling a far distance
     * While moving very fast
     * While riding a minecart at maximum speed
     * While burning (when not fireproof)
     * While levitating
     * While glowing
   * Pain:
     * There is a pain value associated with how much health the player is missing, and how starving they are. There are three levels of pain, with face lines and unhappy eyebrows that can express this.
 * Custom emotes triggered by actions, synced with other players with pings, which can all be applied in any combination:
   * Blushing
   * Large eyes
   * Raising an eyebrow
   * Serious eyebrows
 * Blinking eyes, but only when open
 * Getting wet in rain slowly, or when submerged in water. While wet the character will:
   * Have droopy fur
   * Have droopy ears
   * Emit water particles from the body
   * Slowly dry off when out of water and rain
 * Syncing clothing with skin layers
 * Hiding the hood when the jacket is disabled, or while wearing armour (but not an Elytra)
 * Tucking the ears under helmets
 * Occasionally twitching an ear
 
## Model
The model is simple, but well designed:
 * Non-cube meshes have been optimised to reduce faces
 * The skin layers are 3D (except for the head), and aligned to body pixels
 * The tail segments pivots are set such that the tail is nicely flush in most circumstances
 * A non-square appearance has been avoided in all circumstances, but some parts are angled
 * UVs are well laid out, and several face parts mirror and duplicate sprites with clever UV usage to use less texture space
 * Clipping textures have been avoided with tiny offsets
 * Only three textures are used (the third is a necessarily seperate emission map)

## Credits
Made with the help of FanYang's non-official documentation
https://applejuiceyy.github.io/figs/
