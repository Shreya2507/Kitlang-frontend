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
          background: "assets/introductions/bg4.jpeg",
          character1: "assets/introductions/thinking.png",
          character2: "assets/introductions/employee.gif",
          scene: "Zhua tries to navigate public transport",
          conversations: [
            {
              "speaker": "character1",
              "text": "I need to get to Alexanderplatz... but how?",
            },
            {
              "speaker": "character1",
              "text": "These ticket machines are so confusing!",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text": "Kann ich Ihnen helfen?",
              "character2": "assets/introductions/employee.gif",
            },
            {
              "speaker": "character1",
              "text": "Uh... Alexanderplatz? Ticket?",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text": "Einzelfahrt oder Tageskarte? Zone AB bitte.",
              "character2": "assets/introductions/explain.png",
            },
            {
              "speaker": "character1",
              "text": "I have no idea what they're saying!",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua master daily life in Germany! Complete this chapter to learn essential phrases.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 5:
        return ConvoData(
          background: "assets/introductions/bg5.jpeg",
          character1: "assets/introductions/smile.png",
          character2: "assets/introductions/friend_hello.gif",
          scene: "Zhua makes new friends at a café",
          conversations: [
            {
              "speaker": "character1",
              "text":
                  "I've learned so much! Maybe I can make some friends now.",
            },
            {
              "speaker": "character2",
              "text": "Hallo! Darf ich mich zu Ihnen setzen?",
              "character2": "assets/introductions/friend_hello.gif",
            },
            {
              "speaker": "character1",
              "text": "Äh... ja! Natürlich!",
              "character1": "assets/introductions/smile.png",
            },
            {
              "speaker": "character2",
              "text": "Woher kommen Sie? Was machen Sie hier in Berlin?",
              "character2": "assets/introductions/friend_curious.gif",
            },
            {
              "speaker": "character1",
              "text": "I... uh... Ich komme aus... space?",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text": "...Space? Wie interessant!",
              "character2": "assets/introductions/friend_laugh.gif",
            },
            {
              "speaker": "character1",
              "text": "...",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua with social interactions! Complete this chapter to learn conversation skills.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 6:
        return ConvoData(
          background: "assets/introductions/bg6.jpeg",
          character1: "assets/introductions/character1.gif",
          character2: "assets/introductions/explain.png",
          scene: "Zhua looks for an apartment",
          conversations: [
            {
              "speaker": "character1",
              "text":
                  "I can't keep living in my spaceship. I need a real home!",
            },
            {
              "speaker": "character2",
              "text": "Zhua goes to look for an apartment",
              "character2": "assets/introductions/bora.png",
            },
            {
              "speaker": "character2",
              "text": "Guten Tag! Sie sind hier wegen der Wohnung?",
              "character2": "assets/introductions/explain.png",
            },
            {
              "speaker": "character1",
              "text": "Ja! Die Wohnung ist... schön?",
              "character1": "assets/introductions/nice.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Haben Sie einen Arbeitsvertrag? Wie hoch ist Ihr Nettoeinkommen?",
              "character2": "assets/introductions/explain.png",
            },
            {
              "speaker": "character1",
              "text": "I don't understand any of this!",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua navigate German home life! Complete this chapter for essential vocabulary.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 7:
        return ConvoData(
          background: "assets/introductions/bg7.jpeg",
          character1: "assets/introductions/oh.png",
          character2: "assets/introductions/1_2.gif",
          scene: "Zhua experiences German culture",
          conversations: [
            {
              "speaker": "character1",
              "text": "What is this amazing festival? Everyone's so happy!",
            },
            {
              "speaker": "character2",
              "text": "Prost! Zum Wohl!",
              "character2": "assets/introductions/friend_fun.gif",
            },
            {
              "speaker": "character1",
              "text": "Prost! ...What does that mean?",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text": "Möchtest du Brezeln und Weißwurst probieren?",
              "character2": "assets/introductions/offer.png",
            },
            {
              "speaker": "character1",
              "text": "I don't know what this is, but it tastes delicious!",
              "character1": "assets/introductions/eating.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua understand German culture! Complete this chapter to learn traditions and etiquette.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 8:
        return ConvoData(
          background: "assets/introductions/bg8.jpeg",
          character1: "assets/introductions/suit.gif",
          character2: "assets/introductions/employer.gif",
          scene: "Zhua's first job interview",
          conversations: [
            {
              "speaker": "character1",
              "text":
                  "I need a job to pay for my daily expenses and apartment.",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text": "Zhua goes to a job interview...",
              "character2": "assets/introductions/bora.png",
            },
            {
              "speaker": "character2",
              "text": "Erzählen Sie mir etwas über Ihre Berufserfahrung.",
            },
            {
              "speaker": "character1",
              "text": "Ich... äh... habe Erfahrung mit... spaceships?",
            },
            {
              "speaker": "character2",
              "text":
                  "Interessant. Und warum möchten Sie für unser Unternehmen arbeiten?",
            },
            {
              "speaker": "character1",
              "text": "Because... money?",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua with professional German! Complete this chapter for workplace vocabulary.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 9:
        return ConvoData(
          background: "assets/introductions/bg9.jpeg",
          character1: "assets/introductions/smile.png",
          character2: "assets/introductions/friend_guide.png",
          scene: "Zhua travels through Germany",
          conversations: [
            {
              "speaker": "character1",
              "text":
                  "Time to explore beyond Berlin! The scenery looks amazing!",
            },
            {
              "speaker": "character2",
              "text":
                  "Guten Tag! Möchten Sie an der geführten Wanderung teilnehmen?",
            },
            {
              "speaker": "character1",
              "text": "Äh... ja! Wie viel kostet das?",
            },
            {
              "speaker": "character2",
              "text":
                  "Fünfunddreißig Euro pro Person. Wir gehen um zehn Uhr los.",
            },
            {
              "speaker": "character1",
              "text": "I think that's 35 euros at 10am? I'm not sure...",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua with travel German! Complete this chapter for vacation vocabulary.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 10:
        return ConvoData(
          background: "assets/introductions/bg10.jpeg",
          character1: "assets/introductions/smile.png",
          character2: "assets/introductions/friend_party.gif",
          scene: "Zhua attends a birthday party",
          conversations: [
            {
              "speaker": "character1",
              "text": "I was invited to a birthday party! This is so exciting!",
            },
            {
              "speaker": "character2",
              "text":
                  "Herzlich willkommen! Freut mich, dass du kommen konntest!",
              "character2": "assets/introductions/friend_party.gif",
            },
            {
              "speaker": "character1",
              "text": "Alles Gute zur Hochzeit! ...I think?",
            },
            {
              "speaker": "character2",
              "text": "Danke!",
            },
            {
              "speaker": "character1",
              "text":
                  "Wait ! Why do you have candles on the cake ?\nAre you burning it ?",
              "character1": "assets/introductions/oh.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Haha ! Es ist eine Geburtstagstradition. Wir wünschen uns auch etwas !",
            },
            {
              "speaker": "character1",
              "text": "...",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua with life milestones! Complete this chapter for important life event vocabulary.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 11:
        return ConvoData(
          background: "assets/introductions/bg11.jpg",
          character1: "assets/introductions/thinking.png",
          character2: "assets/introductions/friend_guide.png",
          scene: "Zhua gets involved in local community",
          conversations: [
            {
              "speaker": "character1",
              "text": "I want to be part of this neighborhood!",
            },
            {
              "speaker": "character2",
              "text":
                  "Wir suchen Freiwillige für das Stadtteilfest. Interessiert?",
            },
            {
              "speaker": "character1",
              "text": "Freiwillige? Äh... ja, gerne!",
              "character1": "assets/introductions/smile.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Perfekt! Können Sie am Wochenende den Mülltrennungstand betreuen?",
            },
            {
              "speaker": "character1",
              "text": "Müll... what now?",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua with community life! Complete this chapter for civic engagement vocabulary.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 12:
        return ConvoData(
          background: "assets/introductions/bg12.jpg",
          character1: "assets/introductions/character1.gif",
          character2: "assets/introductions/director.png",
          scene: "Zhua explores German media",
          conversations: [
            {
              "speaker": "character1",
              "text": "I want to understand German movies without subtitles!",
            },
            {
              "speaker": "character2",
              "text":
                  "Das war ein toller Tatort, oder? Der Kommissar war brilliant!",
              "character2": "assets/introductions/friend_curious.gif",
            },
            {
              "speaker": "character1",
              "text": "Ja... toll... (I understood maybe three words)",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Die Dialoge waren so tiefgründig und die Kameraführung avantgardistisch!",
              "character2": "assets/introductions/friend_fun.gif",
            },
            {
              "speaker": "character1",
              "text": "I'm just nodding and smiling...",
              "character1": "assets/introductions/nice.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua understand German media! Complete this chapter for entertainment vocabulary.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 13:
        return ConvoData(
          background: "assets/introductions/bg13.jpg",
          character1: "assets/introductions/hungry.gif",
          character2: "assets/introductions/chef.png",
          scene: "Zhua dines at a fancy restaurant",
          conversations: [
            {
              "speaker": "character1",
              "text": "I want to try authentic German cuisine!",
            },
            {
              "speaker": "character2",
              "text":
                  "Heute empfehle ich unseren Sauerbraten mit Spätzle und Rotkohl.",
            },
            {
              "speaker": "character1",
              "text": "Could you say that again... slower?",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Möchten Sie dazu einen trockenen Riesling oder ein dunkles Weizenbier?",
            },
            {
              "speaker": "character1",
              "text": "I'll just point at something on the menu...",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua with food culture! Complete this chapter for culinary vocabulary.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 14:
        return ConvoData(
          background: "assets/introductions/bg14.jpg",
          character1: "assets/introductions/oh.png",
          character2: "assets/introductions/tech.png",
          scene: "Zhua buys a new smartphone",
          conversations: [
            {
              "speaker": "character1",
              "text":
                  "My spaceship communicator won't work on Earth. I need a phone!",
            },
            {
              "speaker": "character2",
              "text":
                  "Dieses Modell hat ein AMOLED-Display, 5G-Konnektivität und eine Dreifachkamera.",
              "character2": "assets/introductions/explain.png",
            },
            {
              "speaker": "character1",
              "text": "I just need to call and use maps...",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Möchten Sie eine Schutzhülle dazu? Und wir haben ein Sonderangebot für eine erweiterte Garantie.",
              "character2": "assets/introductions/offer.png",
            },
            {
              "speaker": "character1",
              "text": "Too many options! Just give me the blue one!",
              "character1": "assets/introductions/surprised.gif",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua with technology terms! Complete this chapter for digital vocabulary.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
          ],
        );
      case 15:
        return ConvoData(
          background: "assets/introductions/bg15.jpg",
          character1: "assets/introductions/thinking.png",
          character2: "assets/introductions/friend_guide.png",
          scene: "Zhua focuses on self-improvement",
          conversations: [
            {
              "speaker": "character1",
              "text":
                  "After all this studying, I need some balance in my life!",
            },
            {
              "speaker": "character2",
              "text":
                  "Atmen Sie tief ein... und aus... finden Sie Ihr inneres Gleichgewicht.",
            },
            {
              "speaker": "character1",
              "text": "(whispering) What does 'Gleichgewicht' mean again?",
              "character1": "assets/introductions/oh.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Konzentrieren Sie sich auf Ihre Work-Life-Balance und mentale Gesundheit.",
              "character2": "assets/introductions/friend_happy.png",
            },
            {
              "speaker": "character1",
              "text":
                  "I'm trying to concentrate, but I keep thinking about vocabulary!",
              "character1": "assets/introductions/thinking.png",
            },
            {
              "speaker": "character2",
              "text":
                  "Let's help Zhua with personal growth! Complete this final chapter for self-improvement vocabulary.",
              "character2": "assets/introductions/bora.png",
              "action": "navigate"
            },
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
