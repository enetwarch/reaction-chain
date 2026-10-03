class AppDurations {
  /// Near-instant feedback. The highlight on a cell that is about to
  /// explode: it should land and leave before the player notices a fade.
  static const flash = Duration(milliseconds: 50);

  /// Quick responses to a tap. The orb pop-in and the armed highlight
  /// fading in.
  static const fast = Duration(milliseconds: 200);

  /// Short fade-outs and settling. A highlight fading back to the base
  /// color when it is cleared or replaced.
  static const brisk = Duration(milliseconds: 300);

  /// Standard transitions. Slower fade-outs, like the armed highlight
  /// disappearing, where the motion should be easy to follow.
  static const medium = Duration(milliseconds: 500);

  /// Slow, ambient motion. One half-cycle of the blink pulse.
  static const slow = Duration(milliseconds: 1000);

  /// How long an armed cell waits for a confirming tap before it
  /// disarms on its own. This is a timeout, not an animation, so it
  /// should not be tuned along with the visual durations above.
  static const arm = Duration(seconds: 5);
}
