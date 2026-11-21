import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from model_training import normalize_label, preprocess_text, train_models  # noqa: E402
from predict import analyze_email  # noqa: E402
from utils import LEGIT_SAMPLE, PHISHING_SAMPLE, analyze_email_indicators, create_pdf_report, create_txt_report  # noqa: E402


def test_normalize_label():
    assert normalize_label("Phishing") == 1
    assert normalize_label("ham") == 0
    assert normalize_label(1) == 1


def test_preprocess_replaces_urls():
    assert "urltoken" in preprocess_text("visit https://bit.ly/x now")


def test_train_and_predict():
    meta = train_models(force=True)
    assert meta["best_model_name"]
    phish = analyze_email(PHISHING_SAMPLE)
    legit = analyze_email(LEGIT_SAMPLE)
    assert phish["prediction"] == "Phishing"
    assert legit["prediction"] == "Legitimate"
    assert 0 <= phish["risk_score"] <= 100


def test_indicators_and_reports():
    ind = analyze_email_indicators(PHISHING_SAMPLE)
    assert ind["Shortened URLs"]
    result = analyze_email(PHISHING_SAMPLE)
    assert create_txt_report(result).startswith(b"AI-Driven")
    assert create_pdf_report(result)[:4] == b"%PDF"


def test_empty_email_does_not_crash():
    assert analyze_email("")["prediction"] in {"Phishing", "Legitimate"}
