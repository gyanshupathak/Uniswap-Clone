import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        Pink: {
          100: "#FCE4EC",
          200: "#F8BBD0",
          300: "#F48FB1",
          400: "#F06292",
          500: "#EC407A",
          600: "#D81B60",
          700: "#C2185B",
          800: "#AD1457",
          900: "#880E4F",
        },
        White: {
          100: "#FFFFFF",
          200: "#FAFAFA",
          300: "#F5F5F5",
          400: "#EEEEEE",
          500: "#E0E0E0",
          600: "#BDBDBD",
          700: "#9E9E9E",
          800: "#757575",
          900: "#616161",
        },
        Black: {
          100: "#000000",
          200: "#212121",
          300: "#424242",
          400: "#616161",
          500: "#757575",
          600: "#9E9E9E",
          700: "#BDBDBD",
          800: "#E0E0E0",
          900: "#EEEEEE",
        },
        Purple: {
          100: "#F3E5F5",
          200: "#E1BEE7",
          300: "#CE93D8",
          400: "#BA68C8",
          500: "#AB47BC",
          600: "#9C27B0",
          700: "#8E24AA",
          800: "#7B1FA2",
          900: "#6A1B9A",
        }
      },
      fontFamily: {
        sans: ['Poppins', 'sans-serif'],
        mono: ['Roboto Mono', 'monospace'],
      },
    },
  },
  plugins: [],
};
export default config;
