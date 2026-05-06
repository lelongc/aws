import os
import sys
import mimetypes
import struct
import json
import hashlib
import time
import markdown
from bs4 import BeautifulSoup
from google import genai
from google.genai import types

sys.stdout.reconfigure(encoding='utf-8')

API_KEY = os.environ.get("GEMINI_API_KEY") or "AIzaSyC5VQ0evKh2nG-eRUogSVYqvy9FtmzUu_A"
if not API_KEY:
    print("Error: GEMINI_API_KEY environment variable is not set.")
    sys.exit(1)

client = genai.Client(api_key=API_KEY)
MODEL_NAME = "gemini-3.1-flash-tts-preview"

BASE_DIR = r"docs/stephane" if not os.path.exists(r"d:\folder\aws\saa\my-website\docs\stephane") else r"d:\folder\aws\saa\my-website\docs\stephane"
AUDIO_OUTPUT_DIR = r"docs/assets/audio/stephane" if not os.path.exists(r"d:\folder\aws\saa\my-website\docs\assets\audio\stephane") else r"d:\folder\aws\saa\my-website\docs\assets\audio\stephane"
HASH_FILE = os.path.join(AUDIO_OUTPUT_DIR, "audio_hashes.json")

def get_md5(text):
    return hashlib.md5(text.encode('utf-8')).hexdigest()

def load_hashes():
    if os.path.exists(HASH_FILE):
        try:
            with open(HASH_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        except:
            return {}
    return {}

def save_hashes(hashes):
    with open(HASH_FILE, 'w', encoding='utf-8') as f:
        json.dump(hashes, f, indent=4)

def md_to_text(md_content):
    html = markdown.markdown(md_content)
    soup = BeautifulSoup(html, "html.parser")
    for pre in soup.find_all('pre'):
        pre.decompose()
    for code in soup.find_all('code'):
        code.decompose()
    return soup.get_text()

def parse_audio_mime_type(mime_type: str) -> dict:
    bits_per_sample = 16
    rate = 24000
    parts = mime_type.split(";")
    for param in parts:
        param = param.strip()
        if param.lower().startswith("rate="):
            try:
                rate = int(param.split("=", 1)[1])
            except (ValueError, IndexError):
                pass
        elif param.startswith("audio/L"):
            try:
                bits_per_sample = int(param.split("L", 1)[1])
            except (ValueError, IndexError):
                pass
    return {"bits_per_sample": bits_per_sample, "rate": rate}

def convert_to_wav(audio_data: bytes, mime_type: str) -> bytes:
    parameters = parse_audio_mime_type(mime_type)
    bits_per_sample = parameters["bits_per_sample"]
    sample_rate = parameters["rate"]
    num_channels = 1
    data_size = len(audio_data)
    bytes_per_sample = bits_per_sample // 8
    block_align = num_channels * bytes_per_sample
    byte_rate = sample_rate * block_align
    chunk_size = 36 + data_size

    header = struct.pack(
        "<4sI4s4sIHHIIHH4sI",
        b"RIFF",          # ChunkID
        chunk_size,       # ChunkSize
        b"WAVE",          # Format
        b"fmt ",          # Subchunk1ID
        16,               # Subchunk1Size
        1,                # AudioFormat
        num_channels,     # NumChannels
        sample_rate,      # SampleRate
        byte_rate,        # ByteRate
        block_align,      # BlockAlign
        bits_per_sample,  # BitsPerSample
        b"data",          # Subchunk2ID
        data_size         # Subchunk2Size
    )
    return header + audio_data

def generate_tts(text, output_file, max_retries=3):
    contents = [
        types.Content(
            role="user",
            parts=[
                types.Part.from_text(text="Hãy đọc đoạn văn sau rõ ràng, trôi chảy bằng tiếng Việt. Nếu có từ chuyên ngành IT tiếng Anh như AWS, EC2, hãy đọc theo phiên âm chuẩn (Ví dụ: A Đắp Lưu Ét, Y Xi Hai). Đoạn văn:\n" + text),
            ],
        ),
    ]
    
    config = types.GenerateContentConfig(
        temperature=0.7,
        response_modalities=["audio"],
        speech_config=types.SpeechConfig(
            voice_config=types.VoiceConfig(
                prebuilt_voice_config=types.PrebuiltVoiceConfig(
                    voice_name="Kore" 
                )
            )
        ),
    )

    for attempt in range(max_retries):
        try:
            full_audio_data = bytearray()
            for chunk in client.models.generate_content_stream(
                model=MODEL_NAME,
                contents=contents,
                config=config,
            ):
                if not chunk.parts:
                    continue
                part = chunk.parts[0]
                if part.inline_data and part.inline_data.data:
                    inline_data = part.inline_data
                    data_buffer = inline_data.data
                    file_extension = mimetypes.guess_extension(inline_data.mime_type)
                    if file_extension is None:
                        data_buffer = convert_to_wav(data_buffer, inline_data.mime_type)
                    full_audio_data.extend(data_buffer)

            if full_audio_data:
                with open(output_file, "wb") as f:
                    f.write(full_audio_data)
                return True
            return False
            
        except Exception as e:
            print(f"    [Lỗi] Lần thử {attempt + 1}/{max_retries} thất bại: {e}")
            if attempt < max_retries - 1:
                print("    Đang chờ 10 giây trước khi thử lại...")
                time.sleep(10)
            else:
                print("    Đã thử tối đa số lần, bỏ qua file này.")
                return False

def main():
    if not os.path.exists(AUDIO_OUTPUT_DIR):
        os.makedirs(AUDIO_OUTPUT_DIR, exist_ok=True)
        
    hashes = load_hashes()
    hashes_changed = False

    print("Starting folder scan:", BASE_DIR)
    
    for root, dirs, files in os.walk(BASE_DIR):
        for file in files:
            if file.endswith(".md"):
                md_path = os.path.join(root, file)
                
                rel_path = os.path.relpath(md_path, BASE_DIR)
                audio_rel_path = rel_path.replace(".md", ".wav")
                audio_output_path = os.path.join(AUDIO_OUTPUT_DIR, audio_rel_path)
                
                os.makedirs(os.path.dirname(audio_output_path), exist_ok=True)
                
                with open(md_path, 'r', encoding='utf-8') as f:
                    md_content = f.read()
                
                plain_text = md_to_text(md_content)
                clean_text = " ".join(plain_text.split())
                
                if len(clean_text) < 10:
                    continue
                
                # Check Hash
                current_hash = get_md5(clean_text)
                if hashes.get(rel_path) == current_hash and os.path.exists(audio_output_path):
                    print(f"Skipping (unchanged): {rel_path}")
                    continue
                
                print(f"\n--- Processing: {rel_path} ---")
                print("  Calling Gemini TTS API...")
                
                success = generate_tts(clean_text, audio_output_path)
                if success:
                    print(f"  -> Audio saved: {audio_output_path}")
                    hashes[rel_path] = current_hash
                    hashes_changed = True
                    # Rate limit handling between successful files
                    print("  -> Đang ngủ 5s để tránh Rate Limit...")
                    time.sleep(5)
                else:
                    print(f"  -> Audio generation failed.")
                    
    if hashes_changed:
        save_hashes(hashes)
        print("\nĐã cập nhật file audio_hashes.json.")
    print("\nHoàn tất xử lý Audio.")

if __name__ == "__main__":
    main()
