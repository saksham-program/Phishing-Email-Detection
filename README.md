# AI-Driven Phishing Email Detection

[![CI](https://github.com/YOUR-USERNAME/phishing-email-detection/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR-USERNAME/phishing-email-detection/actions)
![Python](https://img.shields.io/badge/python-3.10%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)

A Streamlit dashboard that scores emails as **Phishing** or **Legitimate** using NLP + machine learning,
and explains the decision with extracted indicators (links, urgency language, credential requests, spoofed domains...).

## Features

- Paste an email, or upload `.txt` / `.eml` files
- **Batch mode:** upload a CSV (column named `text`, `body`, `email`, `message`, `content` or `mail`), score every row and download results
- Trains and compares 5 models (Logistic Regression, Naive Bayes, Random Forest, Decision Tree, linear SVM) and keeps the best by F1
- Indicator extraction: URLs, shortened URLs, IPs, emails, phones, HTML, attachments, urgent/financial/password keywords, suspicious domains
- Risk meter, probability chart, confusion matrix, feature importance, word cloud, keyword frequency
- PDF and TXT report download, saved analysis history, dark/light theme
- Auto-trains on first launch; Docker, Procfile and GitHub Actions CI included

## Quick start

```bash
git clone https://github.com/YOUR-USERNAME/phishing-email-detection.git
cd phishing-email-detection
python -m venv .venv
source .venv/bin/activate         # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python model_training.py          # optional - the app trains itself if needed
streamlit run app.py              # http://localhost:8501
```

Shortcuts: `./run.sh` (Linux/macOS) or double-click `run.bat` (Windows).

## Using your own dataset

Replace `dataset/phishing_email_dataset.csv` with a CSV that has a text column (`text`, `email` or `message`)
and a label column (`label`, `target` or `class`). Accepted labels: `1/phishing/spam/fraud/malicious` and
`0/legitimate/ham/safe/normal`. Then run `python model_training.py` to retrain.

## Deployment

- **Streamlit Community Cloud:** push to GitHub, create a new app, main file `app.py`.
- **Docker:** `docker build -t phishing-detector . && docker run -p 8501:8501 phishing-detector`
- **Render / Railway / Heroku:** the `Procfile` starts Streamlit on `$PORT`.

## Project structure

```text
├── app.py               Streamlit UI
├── model_training.py    Data loading, preprocessing, model comparison, artifact saving
├── predict.py           Cached inference + risk scoring
├── utils.py             Indicator extraction, charts, reports, history
├── dataset/             Starter dataset
├── assets/              Logo
├── outputs/             Generated model, vectorizer, metadata, history (git-ignored)
├── tests/               pytest suite
├── .streamlit/config.toml
├── Dockerfile  Procfile  run.sh  run.bat
└── .github/workflows/ci.yml
```

## Testing

```bash
pip install -r requirements-dev.txt
pytest -q
```

## Important limitations

- The bundled dataset is **synthetic** (template-generated, 440 rows), so the reported ~100% accuracy
  is not realistic. For real-world use, train on a real corpus (e.g. the Enron/SpamAssassin/Phishing Email datasets on Kaggle).
- This is an educational tool and should not be the only defence against phishing.
- Generated model files are git-ignored because they depend on your scikit-learn version.

## License

MIT
