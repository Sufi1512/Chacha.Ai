import 'package:allen/featurebox.dart';
import 'package:flutter/material.dart';
import 'package:allen/pallete.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  String lastWords = '';
  @override
  void initState() {
    super.initState();
    initSpeechtoText();
  }

  Future<void> initSpeechtoText() async {
    await speechToText.initialize();
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
        title: const Text('CHaCHa.AI',style: TextStyle(fontFamily: 'Cera Pro',fontStyle: FontStyle.italic,decorationStyle: TextDecorationStyle.wavy),),
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
                decoration: const BoxDecoration(shape: BoxShape.circle,image: DecorationImage(image: AssetImage('assets/images/virtualAssistant.png'))),
                
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
          Container(
            child: const Padding(
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if(await speechToText.hasPermission && !speechToText.isListening){
           await startListening();
           Fluttertoast.showToast(
        msg: "Recording Started",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
          }
          else if(speechToText.isListening){
           await stopListening();
           Fluttertoast.showToast(
        msg: "Recording Stopped",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
           
          }
          else{
            initSpeechtoText();
            Fluttertoast.showToast(
        msg: "Permission Denied",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
          }
        },
        backgroundColor: Pallete.assistantCircleColor,
        child: const Icon(Icons.mic),
      ),
    );
  }
}
