import 'package:streamit_laravel/utils/extension/string_extension.dart';

class EmbeddedPlayerHelper {
  /// ======================================================
  /// PUBLIC ENTRY POINT
  /// ======================================================
  static String getHTML(
    String input, {
    bool autoplay = true,
    Duration? startAt,
    bool mute = true,
  }) {
    final url = input.getURLFromIFrame;

    if (url.isVimeoLink) {
      return getVimeoHTML(
        url.getVimeoVideoId,
        autoplay: autoplay,
        startAt: startAt,
        mute: mute,
      );
    } else if (url.isYoutubeLink) {
      return getYoutubeHTML(
        url.getYouTubeId,
        autoplay: autoplay,
        startAt: startAt,
        mute: mute,
      );
    }

    // fallback → Direct MP4 / direct video link
    return getVideoJsHTML(
      url,
      autoplay: autoplay,
      startAt: startAt,
      mute: mute,
    );
  }

  /// ======================================================
  /// DIRECT MP4 (Video.js)
  /// ======================================================
  static String getVideoJsHTML(
    String videoUrl, {
    required bool autoplay,
    Duration? startAt,
    required bool mute,
  }) {
    const template = """
<!DOCTYPE html>
<html>
<head>
  <link href="https://vjs.zencdn.net/8.10.0/video-js.css" rel="stylesheet" />
  <style>
    body { margin: 0; padding: 0; background-color: #000; overflow: hidden; }
    .video-js { width: 100vw; height: 100vh; }
    .vjs-big-play-button { display: none !important; }
  </style>
</head>

<body>
  <video
    id="my-video"
    class="video-js vjs-default-skin vjs-fill"
    playsinline
    webkit-playsinline
    autoplay
    muted
    preload="auto"
    data-setup='{}'>
    <source src="__VIDEO_URL__" type="video/mp4" />
  </video>

  <script src="https://vjs.zencdn.net/8.10.0/video.min.js"></script>

  <script>
    var player = videojs('my-video', {
      controls: false,
      autoplay: __AUTOPLAY__,
      muted: __MUTED__,
      preload: 'auto',
      responsive: true,
      fill: true,
    });

    player.ready(function() {
      var startAt = __START_AT__;

      if (startAt > 0) player.currentTime(startAt);

      if (__AUTOPLAY__) {
        player.play().catch(()=>{});
      }
      
      if(__MUTED__){
        player.muted(true);
      }
    });

    function playVideo(){ player.play(); }
    function pauseVideo(){ player.pause(); }
    function seekTo(sec){ player.currentTime(sec); }
    function setVolume(vol){ player.volume(vol); }
    function mute(){ player.muted(true); }

    function unMute(){
      player.muted(false);
      player.volume(1);
      player.play().catch(()=>{});
    }

    player.on('timeupdate', function() {
      if (!window.flutter_inappwebview) return;

      var msg = JSON.stringify({
        event: 'timeUpdate',
        currentTime: player.currentTime(),
        duration: player.duration()
      });
      window.flutter_inappwebview.callHandler('PlayerEvents', msg);
    });

    player.on('ended', () =>
      window.flutter_inappwebview?.callHandler('PlayerEvents', "ended")
    );
    player.on('play', () =>
      window.flutter_inappwebview?.callHandler('PlayerEvents', "playing")
    );
    player.on('pause', () =>
      window.flutter_inappwebview?.callHandler('PlayerEvents', "paused")
    );
    player.on('waiting', () =>
      window.flutter_inappwebview?.callHandler('PlayerEvents', "buffering")
    );
  </script>
</body>
</html>
""";

    return template
        .replaceAll("__VIDEO_URL__", videoUrl)
        .replaceAll("__AUTOPLAY__", autoplay ? "true" : "false")
        .replaceAll("__MUTED__", mute ? "true" : "false")
        .replaceAll("__START_AT__", "${startAt?.inSeconds ?? 0}");
  }

  /// ======================================================
  /// YOUTUBE PLAYER
  /// ======================================================
  static String getYoutubeHTML(
    String videoId, {
    required bool autoplay,
    Duration? startAt,
    required bool mute,
  }) {
    const template = """
<html>
<body style="margin:0;padding:0;overflow:hidden;background:black;">
  <div id="player" style="width:100%;height:100%;position:relative;"></div>

  <div id="tapBlocker"
       style="position:absolute;top:0;left:0;width:100%;height:100%;
              z-index:999;background:transparent;"></div>

  <script>
    console.warn = function(msg){
      if (msg && msg.toString().includes("web-share")) return;
    };
    console.error = function(msg){
      if (msg && msg.toString().includes("postMessage")) return;
    };

    var VIDEO_ID = "__VIDEO_ID__";
    var AUTOPLAY = __AUTOPLAY__;
    var MUTE = __MUTED__;
    var START_AT = __START_AT__;

  </script>

  <script src="https://www.youtube.com/iframe_api"></script>

  <script>
    var player;

    function onYouTubeIframeAPIReady() {
      player = new YT.Player('player', {
        videoId: VIDEO_ID,
        playerVars: {
          autoplay: AUTOPLAY ? 1 : 0,
          mute: MUTE ? 1 : 0,
          controls: 0,
          rel: 0,
          start: START_AT,
          playsinline: 1
        },
        events: {
          'onStateChange': onPlayerStateChange,
          'onReady': onPlayerReady
        }
      });
    }

    function onPlayerReady() {
      if (START_AT > 0) player.seekTo(START_AT, true);
    }

    function onPlayerStateChange(event) {
      if (!window.flutter_inappwebview) return;

      if (event.data === 1) {
        window.flutter_inappwebview.callHandler('PlayerEvents', "playing");
        startTimer();
      }
      else if (event.data === 2) {
        window.flutter_inappwebview.callHandler('PlayerEvents', "paused");
        stopTimer();
      }
      else if (event.data === 0) {
        window.flutter_inappwebview.callHandler('PlayerEvents', "ended");
        stopTimer();
      }
      else if (event.data === 3) {
        window.flutter_inappwebview.callHandler('PlayerEvents', "buffering");
      }
    }

    var intervalId;

    function startTimer() {
      stopTimer();
      intervalId = setInterval(() => {
        var msg = JSON.stringify({
          event: "timeUpdate",
          currentTime: player.getCurrentTime(),
          duration: player.getDuration()
        });
        window.flutter_inappwebview?.callHandler('PlayerEvents', msg);
      }, 400);
    }

    function stopTimer() {
      if (intervalId) clearInterval(intervalId);
      intervalId = null;
    }

    function playVideo(){ player.playVideo(); }
    function pauseVideo(){ player.pauseVideo(); }
    function seekTo(sec){ player.seekTo(sec, true); }
    function mute(){ player.mute(); }

    function unMute(){
      player.unMute();
      player.setVolume(100);
      player.playVideo();
    }

    document.getElementById("tapBlocker")
      .addEventListener("click", e => {
        e.stopPropagation();
        e.preventDefault();
      }, true);
  </script>
</body>
</html>
""";

    return template
        .replaceAll("__VIDEO_ID__", videoId)
        .replaceAll("__AUTOPLAY__", autoplay ? "true" : "false")
        .replaceAll("__MUTED__", mute ? "true" : "false")
        .replaceAll("__START_AT__", "${startAt?.inSeconds ?? 0}");
  }

  /// ======================================================
  /// VIMEO PLAYER
  /// ======================================================
  static String getVimeoHTML(
    String videoId, {
    required bool autoplay,
    Duration? startAt,
    required bool mute,
  }) {
    const template = """
<html>
<body style="margin:0;padding:0;overflow:hidden;background:black;">
  <iframe id="vplayer"
    src="https://player.vimeo.com/video/__VIDEO_ID__?autoplay=__AUTOPLAY__&muted=__MUTED__&background=1&controls=0&title=0&byline=0&portrait=0#t=__START_AT__s"
    allow="autoplay; fullscreen; picture-in-picture"
    style="width:100%;height:100%;border:0;position:relative;"></iframe>

  <div id="tapBlocker"
       style="position:absolute;top:0;left:0;width:100%;height:100%;
              background:transparent;z-index:999;"></div>

  <script src="https://player.vimeo.com/api/player.js"></script>

  <script>
    console.error = function(){};
    console.warn = function(){};

    var player = new Vimeo.Player('vplayer');

    player.ready().then(() => {
      if (__AUTOPLAY__) {
        if(__MUTED__)player.setVolume(0);
        player.play().catch(()=>{});
      }
    });

    function playVideo(){ player.play(); }
    function pauseVideo(){ player.pause(); }
    function seekTo(sec){ player.setCurrentTime(sec); }
    function setVolume(vol){ player.setVolume(vol); }
    function mute(){ player.setVolume(0); }
    function unMute(){ player.setVolume(1).then(() => player.play()); }

    player.on('timeupdate', function(data) {
      if (!window.flutter_inappwebview) return;
      var msg = JSON.stringify({
        event: "timeUpdate",
        currentTime: data.seconds,
        duration: data.duration
      });
      window.flutter_inappwebview.callHandler('PlayerEvents', msg);
    });

    player.on('ended', () =>
      window.flutter_inappwebview?.callHandler('PlayerEvents', "ended")
    );
    player.on('pause', () =>
      window.flutter_inappwebview?.callHandler('PlayerEvents', "paused")
    );
    player.on('play', () =>
      window.flutter_inappwebview?.callHandler('PlayerEvents', "playing")
    );

    document.getElementById("tapBlocker")
      .addEventListener("click", e => {
        e.stopPropagation();
        e.preventDefault();
      }, true);
  </script>
</body>
</html>
""";

    return template
        .replaceAll("__VIDEO_ID__", videoId)
        .replaceAll("__AUTOPLAY__", autoplay ? "1" : "0")
        .replaceAll("__MUTED__", mute ? "1" : "0")
        .replaceAll("__START_AT__", "${startAt?.inSeconds ?? 0}");
  }
}