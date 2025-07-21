curl -X POST -H "Content-Type: application/json" \
-H "X-Goog-User-Project: $(gcloud config list --format='value(core.project)')" \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
--data '{
"input": {
  "markup": "Chapter 1: The Discovery of the Voice Crystals\n\nOur quest began when we encountered the Google Cloud Text-to-Speech service—not just any speech synthesizer, but a collection of neural voice crystals capable of transforming written words into natural, engaging speech. These weren\u0027t the robotic voices of old; these were sophisticated artificial spirits that could breathe life into technical narratives.\n\nThe Sacred API …  "name": "en-GB-Chirp3-HD-Achernar",
  "voiceClone": {
  }
},
"audioConfig": {
  "audioEncoding": "LINEAR16"
}
}' "https://texttospeech.googleapis.com/v1/text:synthesize"