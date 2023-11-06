import 'package:allen/featurebox.dart';
import 'package:allen/serveice.dart';
import 'package:allen/toats.dart';
import 'package:flutter/material.dart';
import 'package:allen/pallete.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  String lastWords = '';
  bool speechEnabled = false;
  final OpenAIservice openAIservice = OpenAIservice();

  @override
  void initState() {
    super.initState();

    initSpeechtoText();
  }

  Future<void> initSpeechtoText() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      print(result.recognizedWords);
    });
  }

  double fontSizeTitle = 20; // Initial value
  double suggestionBoxWidth = 0.8; // Initial value

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Update breakpoints for responsiveness
    fontSizeTitle = screenWidth > 600 ? 25 : 20;
    suggestionBoxWidth = screenWidth > 600 ? 600 : screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHaCHa.AI',
          style: TextStyle(
              fontFamily: 'Cera Pro',
              fontStyle: FontStyle.italic,
              decorationStyle: TextDecorationStyle.wavy),
        ),
        centerTitle: true,
        backgroundColor: Pallete.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
          color: Pallete.assistantCircleColor,
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              // The assistant circle
              Center(
                child: Container(
                  height: screenHeight * 0.12,
                  width: screenHeight * 0.12,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Pallete.assistantCircleColor,
                  ),
                ),
              ),
              Container(
                // The assistant circle's border
                decoration: const BoxDecoration(shape: BoxShape.circle),
              ),
              Container(
                // The assistant image
                height: screenHeight * 0.12,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/virtualAssistant.png'))),
              ),
            ],
          ),
          // The suggestion boxes
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20).copyWith(
                topLeft: const Radius.circular(0),
              ),
              border: Border.all(color: Pallete.borderColor),
            ),
            // The first suggestion box
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Hello, Dosto. I am here to help you. How can I help you today?',
                style: TextStyle(
                  color: Pallete.mainFontColor,
                  fontSize: fontSizeTitle,
                  fontFamily: 'Cera Pro',
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Features',
                style: TextStyle(
                  color: Pallete.mainFontColor,
                  fontSize: 18,
                  fontFamily: 'Cera Pro',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // The suggestion LIST
          Column(
            children: [
              FeatureBox(
                header: 'ChatGPT',
                Desctext: 'ChatGPT is a chatbot that can chat with you.',
                color: Pallete.firstSuggestionBoxColor,
                maxWidth: suggestionBoxWidth, // Pass the maxWidth
              ),
              FeatureBox(
                color: Pallete.secondSuggestionBoxColor,
                header: 'DALL·E',
                Desctext: 'DALL·E is an AI that can generate images from text.',
                maxWidth: suggestionBoxWidth, // Pass the maxWidth
              ),
              FeatureBox(
                color: Pallete.thirdSuggestionBoxColor,
                header: 'Voice Assistance',
                Desctext:
                    'Voice Assistance is a voice assistant that can help you.',
                maxWidth: suggestionBoxWidth, // Pass the maxWidth
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              // If listening is active show the recognized words
              speechToText.isListening
                  ? lastWords
                  // If listening isn't active but could be tell the user
                  // how to start it, otherwise indicate that speech
                  // recognition is not yet ready or not supported on
                  // the target device
                  : speechEnabled
                      ? 'Tap the microphone to start listening...'
                      : 'Speech not available',
              style: const TextStyle(fontFamily: 'Cera Pro'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
            ToastUtil.showToast('Recording Started');
          } else if (speechToText.isListening) {
            openAIservice.isArtPromptAPI(lastWords);

            await stopListening();
            ToastUtil.showToast('Recording Stopped');
          } else {
            initSpeechtoText();
            ToastUtil.showToast("Permission Denied");
          }
        },
        backgroundColor: Pallete.assistantCircleColor,
        tooltip: 'Listen',
        child: Icon(speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
