package com.example.audio_player

import kotlin.random.Random
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.provider.MediaStore
import android.database.Cursor
import android.net.Uri
import android.util.Log
import kotlinx.serialization.*
import kotlinx.serialization.json.*

@Serializable
data class AudioModel(
    var trackName: String? = null,
    var trackDetail: String? = null,
    var trackUrl: String? = null
)

private const val mTAG = "MainActivity"

fun getAllAudioFromDevice(context: Context): List<AudioModel>? {
    val tempAudioList: MutableList<AudioModel> = ArrayList()
    val uri: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    val projection = arrayOf<String>(
        MediaStore.Audio.AudioColumns.DATA,
        MediaStore.Audio.AudioColumns.TITLE,
        MediaStore.Audio.ArtistColumns.ARTIST,
    )
    val selection = MediaStore.Audio.Media.IS_MUSIC + " != 0"
    /*val projection = arrayOf(
        MediaStore.Audio.Media._ID,
        MediaStore.Audio.Media.ARTIST,
        MediaStore.Audio.Media.TITLE,
        MediaStore.Audio.Media.DATA,
        MediaStore.Audio.Media.DISPLAY_NAME,
        MediaStore.Audio.Media.DURATION
    )*/
    val c: Cursor? = context.contentResolver.query(
        uri, projection, selection, null, null
    )
    if (c != null) {
        while (c.moveToNext()) {
            val audioModel = AudioModel()
            val path = c.getString(0)
            val name = c.getString(1)
            val artist = c.getString(2)
            audioModel.trackName = name
            audioModel.trackDetail = artist
            audioModel.trackUrl = path
            if(path != null && (path.endsWith(".aac")
                        || path.endsWith(".mp3")
                        || path.endsWith(".wav")
                        || path.endsWith(".ogg")
                        || path.endsWith(".ac3")
                        || path.endsWith(".m4a"))) {

                Log.v(mTAG, "trackName :${audioModel.trackName}, trackDetail :${audioModel.trackDetail}, trackUrl :${audioModel.trackUrl}")
                tempAudioList.add(audioModel)
            }
        }
        c.close()
    }

    return tempAudioList
}

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "example.com/channel").setMethodCallHandler {
      call, result ->
        if(call.method == "getRandomNumber") {
//          val rand = Random.nextInt(100)
            val rand = getAllAudioFromDevice(this);
            Log.v(mTAG, "tempAudioList length: ${rand?.size}")
            if (rand != null && rand.isNotEmpty()) {
                val jsonString = Json.encodeToString(rand)
                result.success(jsonString)
            } else {
                result.success(-1)
            }



        }
        else {
          result.notImplemented()
        }
    }
  }
}
