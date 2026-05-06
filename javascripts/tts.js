document.addEventListener("DOMContentLoaded", function() {
    // Check if SpeechSynthesis is supported
    if (!('speechSynthesis' in window)) {
        console.warn("Trình duyệt không hỗ trợ Web Speech API");
        return;
    }

    const contentContainer = document.querySelector('.md-content__inner') || document.querySelector('article');
    if (!contentContainer) return;

    // Collect all text chunks to read
    const elementsToRead = contentContainer.querySelectorAll('h1, h2, h3, h4, h5, h6, p, li');
    let textChunks = [];

    elementsToRead.forEach(el => {
        // Skip some elements that shouldn't be read (like code blocks, headers anchors)
        if (el.closest('.md-source') || el.closest('.md-clipboard') || el.closest('pre')) {
            return;
        }
        
        let text = el.innerText || el.textContent;
        // Clean up common symbols
        text = text.replace(/¶/g, '').trim(); 
        
        if (text.length > 0) {
            textChunks.push(text);
        }
    });

    if (textChunks.length === 0) return;

    // Build UI
    const ttsContainer = document.createElement('div');
    ttsContainer.className = 'tts-container';
    
    // SVG Icons
    const playIcon = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>`;
    const pauseIcon = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/></svg>`;
    const stopIcon = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M6 6h12v12H6z"/></svg>`;

    const playBtn = document.createElement('button');
    playBtn.className = 'tts-btn tts-btn-play';
    playBtn.innerHTML = playIcon;
    playBtn.title = 'Phát / Tạm dừng';

    const stopBtn = document.createElement('button');
    stopBtn.className = 'tts-btn tts-btn-stop';
    stopBtn.innerHTML = stopIcon;
    stopBtn.title = 'Dừng lại';
    stopBtn.style.display = 'none'; // Hide stop initially

    const statusText = document.createElement('div');
    statusText.className = 'tts-status';
    statusText.innerText = 'Nghe bài viết';

    ttsContainer.appendChild(playBtn);
    ttsContainer.appendChild(stopBtn);
    ttsContainer.appendChild(statusText);

    // Insert into DOM just below h1, or at top
    const h1 = contentContainer.querySelector('h1');
    if (h1 && h1.nextSibling) {
        h1.parentNode.insertBefore(ttsContainer, h1.nextSibling);
    } else {
        contentContainer.insertBefore(ttsContainer, contentContainer.firstChild);
    }

    // State
    let currentIndex = 0;
    let isPlaying = false;
    let currentUtterance = null;

    // Helper: Find Vietnamese voice
    function getVietnameseVoice() {
        const voices = window.speechSynthesis.getVoices();
        // Try finding a Vietnamese voice
        const viVoice = voices.find(v => v.lang === 'vi-VN' || v.lang === 'vi');
        // Fallback to first available voice if no VN voice found
        return viVoice || voices[0];
    }

    // Force load voices (Chrome quirk)
    window.speechSynthesis.onvoiceschanged = getVietnameseVoice;

    function playChunk() {
        if (currentIndex >= textChunks.length) {
            stopTTS();
            return;
        }

        const text = textChunks[currentIndex];
        currentUtterance = new SpeechSynthesisUtterance(text);
        
        const voice = getVietnameseVoice();
        if (voice) {
            currentUtterance.voice = voice;
        }
        currentUtterance.lang = 'vi-VN';
        currentUtterance.rate = 1.0; // Tốc độ bình thường
        currentUtterance.pitch = 1.0;

        currentUtterance.onend = function() {
            // Wait slightly before reading next chunk to simulate natural pause
            setTimeout(() => {
                if (isPlaying) {
                    currentIndex++;
                    playChunk();
                }
            }, 300); // 300ms pause between paragraphs
        };

        currentUtterance.onerror = function(e) {
            console.error("Lỗi đọc văn bản:", e);
            // Sometimes it errors out if cancelled. Just ignore if we cancelled it
        };

        window.speechSynthesis.speak(currentUtterance);
        
        isPlaying = true;
        ttsContainer.classList.add('tts-playing');
        playBtn.innerHTML = pauseIcon;
        statusText.innerText = `Đang đọc (${currentIndex + 1}/${textChunks.length})...`;
        stopBtn.style.display = 'flex';
    }

    function pauseTTS() {
        // Instead of speechSynthesis.pause() which is buggy on mobile,
        // we completely cancel it and keep the currentIndex to resume later.
        window.speechSynthesis.cancel();
        isPlaying = false;
        ttsContainer.classList.remove('tts-playing');
        playBtn.innerHTML = playIcon;
        statusText.innerText = 'Đã tạm dừng';
    }

    function resumeTTS() {
        playChunk();
    }

    function stopTTS() {
        window.speechSynthesis.cancel();
        isPlaying = false;
        currentIndex = 0;
        ttsContainer.classList.remove('tts-playing');
        playBtn.innerHTML = playIcon;
        statusText.innerText = 'Nghe bài viết';
        stopBtn.style.display = 'none';
    }

    playBtn.addEventListener('click', () => {
        if (isPlaying) {
            pauseTTS();
        } else {
            resumeTTS();
        }
    });

    stopBtn.addEventListener('click', () => {
        stopTTS();
    });

    // Handle page unload or visibility change
    window.addEventListener('beforeunload', () => {
        if (isPlaying) stopTTS();
    });
});
