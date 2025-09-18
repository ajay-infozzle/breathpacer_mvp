# Keep just_audio internals
-keep class com.ryanheise.just_audio.** { *; }

# Keep ExoPlayer
-keep class com.google.android.exoplayer2.** { *; }

# Keep AndroidX media support
-keep class androidx.media.** { *; }

# Prevent warnings (optional)
-dontwarn com.google.android.exoplayer2.**
