import 'package:flutter/material.dart';
import 'package:mitr_app/openai_service.dart';
import 'package:mitr_app/pallete.dart';
import 'package:mitr_app/feature_box.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  bool speechEnabled = false;
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  @override
  void initState(){
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }
  Future<void> initTextToSpeech() async{
    setState(() {

    });
  }
  Future<void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {

    });
  }
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    
    setState(() {});
  }


  Future<void> stopListening() async {
    // print(lastWords);
    await speechToText.stop();
    setState(() {});
  }


  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      // print(lastWords);
    });
  }

  Future<void> systemSpeak(String content) async{
    await flutterTts.speak(content);
  }
  @override
  void dispose(){
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mitr"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Pallete.assistantCircleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: 123,
                margin: const EdgeInsets.only(left: 18),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/mitr_assistant.png"
                  ),
                  ),
                ),
              )
            ],
          ),
          //Chat message
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
              top: 30,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Pallete.borderColor,
              ),
              borderRadius: BorderRadius.circular(20).copyWith(
                topLeft: Radius.zero,
              )
            ),
            child: Padding(
              padding:const EdgeInsets.symmetric(vertical:10.0),
            child: Text(
              generatedContent == null 
              ? 'Hello there, Press below mic button to start the converstion!'
              : generatedContent! ,style: TextStyle(
              color: Pallete.mainFontColor,
              fontSize: generatedContent == null ? 18:12,
              fontFamily: 'Cera-Pro',

            ),
            ),
            ),
          ),
          Visibility(
            visible: generatedContent == null,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 10,left: 20),
              child: const Text(
                "My features",
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.mainFontColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if(generatedImageUrl != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(generatedImageUrl.toString()),
            ),
          
          Visibility(
            visible: generatedContent == null && generatedImageUrl == null,
            child: Column(
              children:  [
                const FeatureBox(
                  color:Pallete.firstSuggestionBoxColor,
                  headerText:'ChatGPT',
                  descriptionText: 'You have access to ask with ChatGPT',
                ),
                const FeatureBox(
                  color:Pallete.secondSuggestionBoxColor,
                  headerText:'Dall-E',
                  descriptionText: 'Just ask and Dall -E will show creativity',
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          // print(lastWords);
          if(await speechToText.hasPermission && speechToText.isNotListening){
            await startListening();
          }
          else if(speechToText.isListening){
            
            final speech = await openAIService.isArtPromptAPI(lastWords);
            
            if(speech.contains('https')){
              generatedImageUrl = speech;
              generatedContent = null;
              setState(() {
                
              });
            }else{
              generatedImageUrl = null;
              generatedContent = speech;
              await systemSpeak(speech);
              setState(() {
                
              });
            }
            
            await stopListening();
          }else{
            initSpeechToText();
          }
        },
          child: Icon(
            speechToText.isListening ? Icons.stop : Icons.mic),
      ),
    );
  }
}
