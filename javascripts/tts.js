document.addEventListener("DOMContentLoaded", function() {
    const contentContainer = document.querySelector('.md-content__inner') || document.querySelector('article');
    if (!contentContainer) return;

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
    stopBtn.style.display = 'none';

    const statusText = document.createElement('div');
    statusText.className = 'tts-status';
    statusText.innerText = 'Nghe bài viết (Bản Premium)';

    ttsContainer.appendChild(playBtn);
    ttsContainer.appendChild(stopBtn);
    ttsContainer.appendChild(statusText);

    const h1 = contentContainer.querySelector('h1');
    if (h1 && h1.nextSibling) {
        h1.parentNode.insertBefore(ttsContainer, h1.nextSibling);
    } else {
        contentContainer.insertBefore(ttsContainer, contentContainer.firstChild);
    }

    // Determine Audio URL
    // We use the Edit link to reliably get the current markdown file path
    const editLink = document.querySelector('a.md-content__button');
    let mp3Url = null;

    if (editLink && editLink.href.includes('/docs/')) {
        const mdRelPath = editLink.href.split('/docs/')[1]; // e.g. stephane/01.saa/01.md
        if (mdRelPath) {
            const logoLink = document.querySelector('.md-header__button.md-logo');
            let baseUrl = '/';
            if (logoLink) {
                baseUrl = new URL(logoLink.getAttribute('href'), window.location.href).href;
                if (!baseUrl.endsWith('/')) baseUrl += '/';
            }
            
            mp3Url = baseUrl + "assets/audio/" + mdRelPath.replace('.md', '.wav');
        }
    }

    if (!mp3Url) {
        // Fallback or not a standard markdown page
        ttsContainer.style.display = 'none';
        return;
    }

    // Create Audio Element
    const audio = new Audio(mp3Url);
    let isPlaying = false;

    audio.addEventListener('play', () => {
        isPlaying = true;
        ttsContainer.classList.add('tts-playing');
        playBtn.innerHTML = pauseIcon;
        statusText.innerText = 'Đang phát âm thanh...';
        stopBtn.style.display = 'flex';
    });

    audio.addEventListener('pause', () => {
        isPlaying = false;
        ttsContainer.classList.remove('tts-playing');
        playBtn.innerHTML = playIcon;
        statusText.innerText = 'Đã tạm dừng';
    });

    audio.addEventListener('ended', () => {
        isPlaying = false;
        ttsContainer.classList.remove('tts-playing');
        playBtn.innerHTML = playIcon;
        statusText.innerText = 'Nghe bài viết (Bản Premium)';
        stopBtn.style.display = 'none';
    });

    audio.addEventListener('error', () => {
        statusText.innerText = 'Chưa có file Audio cho trang này';
        playBtn.style.opacity = '0.5';
        playBtn.disabled = true;
    });

    playBtn.addEventListener('click', () => {
        if (isPlaying) {
            audio.pause();
        } else {
            audio.play().catch(e => {
                console.error("Audio play error", e);
                statusText.innerText = 'Lỗi phát Audio';
            });
        }
    });

    stopBtn.addEventListener('click', () => {
        audio.pause();
        audio.currentTime = 0;
        isPlaying = false;
        ttsContainer.classList.remove('tts-playing');
        playBtn.innerHTML = playIcon;
        statusText.innerText = 'Nghe bài viết (Bản Premium)';
        stopBtn.style.display = 'none';
    });
});
