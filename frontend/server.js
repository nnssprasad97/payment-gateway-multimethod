const express = require('express');
const path = require('path');
const app = express();

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Use the regex-based catch-all for newer Express versions
app.get(/^(?!\/api).+/, (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

const PORT = 80;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});