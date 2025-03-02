export function generateLetterHTML(application) {
    return `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Application Letter</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 40px;
        padding: 20px;
        background-color: #f8f9fa;
    }

    .letter-container {
        background: #fff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        max-width: 600px;
        margin: auto;
    }

    .header {
        text-align: left;
        margin-bottom: 20px;
    }

    .recipient {
        margin-bottom: 8px;
    }

    .subject {
        font-weight: bold;
        margin-bottom: 20px;
    }

    .body {
        line-height: 1.6;
        margin-bottom: 50px;
    }

    /* Signature Section */
    .signature-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 80px;
        border-top: 1px solid #ccc;
        padding-top: 20px;
    }

    .signature {
        text-align: center;
    }

    .signature img {
        width: 150px;
        height: auto;
    }

    .signature p {
        margin-top: 5px;
        font-weight: bold;
    }

</style>
    </head>
    <body>
        <div class="letter-container">
            <!-- Sender Details -->
            <div class="header">
                <p>${application.from.name}</p>
                <p>${application.from.email}</p>
                <p>Date: ${new Date(application.createdAt).toLocaleDateString()}</p>
            </div>

            <!-- Recipient Details -->
            <div class="recipient">
                <p>To,</p>
                ${application.to.map(recipient => `
                    <p><strong>${recipient.faculty?.name}</strong></p>
                    <p>${recipient.position}, ${recipient.faculty?.department}</p>
                    <p>${recipient.faculty?.email}</p>
                `).join('')}
            </div>

            <!-- Subject -->
            <div class="subject">
                <strong>Subject:</strong> ${application.title}
            </div>

            <!-- Body -->
            <div class="body">
                <p>Dear ${application.to.map(recipient => recipient.faculty?.name).join(", ")},</p>
                <p>${application.body}</p>
                <p>Sincerely,</p>
                <p><strong>${application.from.name}</strong></p>
               <!--- <img src=${application.from.signature} alt="Signature 1"> --->
            </div>

            <!-- Signature Section (At Bottom) -->
            <div class="signature-container">
                ${application.to.map(recipient => {
                    return `<div class="signature">
                    <img src=${recipient.signature} alt="Signature 2">
                    <p>${recipient.faculty?.name}<br/>${recipient.position}</p>
                </div>`
                })}
            </div>
        </div>
    </body>
    </html>
    `;
}
