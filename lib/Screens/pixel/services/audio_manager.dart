import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager extends Component {
  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.loadAll([
      'jump.wav',
      'Ananas.wav',
      'Apfel.wav',
      'bounce.wav',
      'collect_fruit.wav',
      'disappear.wav',
      'Erdbeere.wav',
      'hit.wav',
      'Kirsche.wav',
      'Kiwi.wav',
      'Orange.wav',
      'Wassermelone.wav',
    ]);
  }

  void play(String fileName) {
    FlameAudio.play(fileName);
  }
}
