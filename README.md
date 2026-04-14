# Kenya's Vanishing Forests

**A data analytics project on deforestation, land rights, and the communities living inside the data.**

> "Where is Kenya losing forest cover, who is driving it, who suffers most — and what happens next?"

---

## About This Project

Kenya has lost roughly 40% of its forest cover since independence — from 10% of land area in 1963 to around 6% today. This project uses 24 years of satellite data cross-referenced with UN and World Bank institutional data to answer four concrete questions about that loss.

Built by **Davis Mironga** — 

---

## Project Structure

| Chapter | Question | Tool | Output |
|---------|----------|------|--------|
| 1 — Where? | Which counties lose forest fastest? | SQL | County ranking + trend chart |
| 2 — Why? | How has the cause of loss shifted by county? | Python | Driver shift analysis |
| 3 — Who? | Which communities bear the highest cost? | Power BI | Interactive dashboard |
| 4 — What next? | Which counties will lose most by 2030? | Python (ML) | Forecast + policy recommendations |

---

## Key Findings

*To be updated as chapters are completed.*

---

## Data Sources

| Dataset | Institution | Coverage |
|---------|-------------|----------|
| Tree cover loss 2001–2024 | Global Forest Watch / UMD | County level |
| Forest area + land use | FAO FAOSTAT | National |
| Forest Resources Assessment | FAO FRA | National |
| Poverty + rural population | World Bank | National + county |

---

## Communities in the Data

This project explicitly names the communities whose lives are inside the numbers:
- **The Ogiek** of the Mau Forest — ancestral land, 2017 African Court ruling
- **The Sengwer** of Cherangany Hills — forced evictions linked to conservation finance
- **Pastoralist communities** in Baringo and Tana River — charcoal production, grazing corridors

---

## How to Reproduce

```bash
git clone https://github.com/davis-mironga/kenya-deforestation-analysis.git
cd kenya-deforestation-analysis
pip install -r requirements.txt
```

Then follow the notebooks in order inside the `notebooks/` folder.

---

## Author

**Davis Mironga** — Data Analyst | Environmental Data | Nairobi, Kenya  
[GitHub](https://github.com/davis-mironga) · [LinkedIn](#)
