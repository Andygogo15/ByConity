SELECT round(hist.1) AS l, round(hist.2) AS r, round(hist.3) AS cnt FROM (SELECT arrayJoin(finalizeAggregation((SELECT histogramState(3)(number) FROM numbers(10, 190)) + (SELECT histogramState(3)(number) FROM numbers(0, 100)))) AS hist);
SELECT round(hist.1) AS l, round(hist.2) AS r, round(hist.3) AS cnt FROM (SELECT arrayJoin(finalizeAggregation((SELECT histogramState(3)(number) FROM numbers(0, 100)) + (SELECT histogramState(3)(number) FROM numbers(10, 190)))) AS hist);
