class ConvoData {
  final String background;
  final String character1;
  final String character2;
  final String scene;
  final List<Map<String, String>> conversations;

  ConvoData({
    required this.background,
    required this.character1,
    required this.character2,
    required this.conversations,
    required this.scene,
  });

  static ConvoData getConvoData(int level) {
    switch (level) {
      case 1:
        return ConvoData(
          background: "assets/introductions/bg1.jpg",
          character1: "assets/introductions/1_1.gif",
          character2: "assets/introductions/1_2.gif",
          scene: "Zhua’s spaceship lands in Berlin",
          conversations: [
            {
              "speaker": "character1",
              "text":
                  "I've finally arrived on Earth! Time to speak to some Earthlings!",
            },
            {"speaker": "character1", "text": "Hello, human! How are you?"},
            {"speaker": "character2", "text": "Entschuldigung?"},
            {
              "speaker": "character1",
              "text": "What?! That’s not English! Uh-oh...",
              "character1":
                  "assets/introductions/surprised.gif", // Example override
            },
            {
              "speaker": "character1",
              "text": "Help Zhua learn his first German word! \n\nSay: Hallo!",
              "action": "prompt",
              "expectedWord": "Hallo",
              "character1": "assets/introductions/bora.png",
            },
            {"speaker": "character1", "text": "Hallo !"},
            {
              "speaker": "character2",
              "text": "Guten Morgen ! Schönen Tag",
              "character2": "assets/introductions/character2.gif",
            },
            {
              "speaker": "character1",
              "text":
                  "Phew! That was awkward. \nI guess I should start learning this language so that I can communicate with the locals..",
              "character1": "assets/introductions/character1.gif",
              "action": "navigate",
            },
          ],
        );
      case 2:
        return ConvoData(
          background: "assets/introductions/bg2.jpg",
          character1: "assets/introductions/smile.png",
          character2: "assets/introductions/character2.gif",
          scene: "Zhua meets a friendly local at the park",
          conversations: [
            {
              "speaker": "character1",
              "text": "Okay, I can introduce myself now !",
            },
            {
              "speaker": "character1",
              "text":
                  "But.... \nI hear other people talking about some things that I cannot understand",
              "character1": "assets/introductions/oh.png",
            },
            {"speaker": "character2", "text": "Guten Morgen!"},
            {"speaker": "character1", "text": "Hallo ! Guten Morgen!"},
            {
              "speaker": "character2",
              "text": "A few moments later",
              "character2": "assets/introductions/bora.png",
            },
            {"speaker": "character2", "text": "Und, was machst du so?"},
            {
              "speaker": "character1",
              "text": "Oh no ! What do i say ??",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Hi ! Bora here...complete all the topics in this chapter so that you can help out Zhua !",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 3:
        return ConvoData(
          background: "assets/introductions/bg3.jpg",
          character1: "assets/introductions/hungry.gif",
          character2: "assets/introductions/annoyed.png",
          scene: "Zhua goes to a bakery",
          conversations: [
            {
              "speaker": "character1",
              "text": "Ugh ! I am feeling really hungry after such a long day"
            },
            {
              "speaker": "character1",
              "text": "Let me buy some delicious bread and pastries !"
            },
            {
              "speaker": "character2",
              "text": "Hallo! Was darf es sein?",
              "character2": "assets/introductions/explain.png",
            },
            {
              "speaker": "character1",
              "text":
                  "Oh no ! How do I say this...uhh...\n\n A pastry please...",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text": "Entschuldigung ?",
              "character2": "assets/introductions/annoyed.png",
            },
            {
              "speaker": "character1",
              "text": "......uh......\n uh.....",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text": "......",
              "character2": "assets/introductions/headShake.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Well....that was awkward.\nComplete all the topics in this chapter so that you can help out Zhua !",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 4:
        return ConvoData(
          background: "assets/default_bg.png",
          character1: "assets/default1.gif",
          character2: "assets/default2.gif",
          scene: "Zhua meets a friendly local",
          conversations: [
            {"speaker": "character1", "text": "Welcome to the game!"},
            {"speaker": "character2", "text": "Let's learn together!"},
          ],
        );
      case 5:
        return ConvoData(
          background: "assets/default_bg.png",
          character1: "assets/default1.gif",
          character2: "assets/default2.gif",
          scene: "Zhua bumps into someone",
          conversations: [
            {"speaker": "character1", "text": "Welcome to the game!"},
            {"speaker": "character2", "text": "Let's learn together!"},
          ],
        );
      default:
        return ConvoData(
          background: "assets/default_bg.png",
          character1: "assets/default1.gif",
          character2: "assets/default2.gif",
          scene: "Looks like there's a network error",
          conversations: [
            {
              "speaker": "character1",
              "text": "Please try again later!",
              "character1": "assets/character1.gif",
            },
          ],
        );
    }
  }
}
