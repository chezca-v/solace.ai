// Add subtle parallax effect to the mockup card
document.addEventListener('mousemove', (e) => {
    const mockup = document.querySelector('.mockup-card');
    if (!mockup || window.innerWidth < 968) return;

    const xAxis = (window.innerWidth / 2 - e.pageX) / 25;
    const yAxis = (window.innerHeight / 2 - e.pageY) / 25;

    // Preserve the original rotation along with the dynamic parallax
    mockup.style.transform = `rotateY(${-10 + xAxis}deg) rotateX(${5 + yAxis}deg)`;
});

// Reset transform on mouse leave
document.addEventListener('mouseleave', () => {
    const mockup = document.querySelector('.mockup-card');
    if (mockup && window.innerWidth >= 968) {
        mockup.style.transform = `rotateY(-10deg) rotateX(5deg)`;
    }
});
