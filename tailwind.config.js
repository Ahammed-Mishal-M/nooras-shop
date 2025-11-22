/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    // This path finds your base.html and other root templates
    './templates/**/*.html',

    // This path finds your app templates (category_detail.html, home.html)
    './store/templates/**/*.html',
  ],
  theme: {
    extend: {
      backgroundImage: {
        // IMPORTANT: Change 'your-image-name.jpg' to your real file name
        'custom-bg': "url('/static/img-pakistani-suits.jpg')",
      }
    },
  },
  plugins: [],
}