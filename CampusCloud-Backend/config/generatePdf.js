import puppeteer from "puppeteer";

export const generatePDF = async (htmlContent, outputPath) => {
  try {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    // Set the HTML content
    await page.setContent(htmlContent, { waitUntil: "domcontentloaded" });

    // Generate PDF and save it to the specified path
    await page.pdf({ path: outputPath, format: "A4" });

    await browser.close();
    console.log(`PDF generated successfully: ${outputPath}`);
  } catch (error) {
    console.error("Error generating PDF:", error);
  }
};
