function toggleDarkMode() {
    const html = document.documentElement;
    html.classList.toggle('dark');
    // Sauvegardez le thème actuel dans le stockage local (localStorage)
    localStorage.setItem('theme', html.classList.contains('dark') ? 'dark' : 'light');
}
// Chargez le thème actuel lors du chargement de la page
(() => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        document.documentElement.classList.add(savedTheme === 'dark' ? 'dark' : 'light');
    } else {
        // Par défaut, utilisez le thème du système d'exploitation
        const darkModeMediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
        if (darkModeMediaQuery.matches) {
            document.documentElement.classList.add('dark');
        }
    }
})();

function tr_display(idDiv) {
    const targetRow = document.getElementById(idDiv);
    targetRow.classList.toggle('hidden');
}
