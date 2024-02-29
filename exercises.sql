-- What grades are stored in the database?
-- 1st through 5th
SELECT * FROM Grade;

-- What emotions may be associated with a poem?
-- anger, fear, sadness, joy
SELECT * From Emotion;

-- How many poems are in the database?
-- 32842
SELECT COUNT(*) FROM Poem;

-- Sort authors alphabetically by name. What are the names of the top 76 authors?
SELECT * FROM Author ORDER BY Name LIMIT 76;

-- Starting with the above query, add the grade of each of the authors.
SELECT a.*, g.Name AS Grade FROM Author AS a
JOIN Grade AS g ON a.GradeId = g.id
ORDER BY Name LIMIT 76;

-- Starting with the above query, add the recorded gender of each of the authors.
SELECT a.*, gr.Name AS Grade, ge.Name AS Gender FROM Author AS a
JOIN Grade AS gr ON a.GradeId = gr.id
JOIN Gender AS ge ON a.GenderId = ge.id
ORDER BY Name LIMIT 76;

-- What is the total number of words in all poems in the database?
-- 374584
SELECT SUM(WordCount) FROM Poem;

-- Which poem has the fewest characters?
-- Id 123, Title Hi
SELECT Id, Title, MIN(CharCount) FROM Poem;

-- How many authors are in the third grade?
-- 2344
SELECT COUNT(a.Id), g.Name FROM Author AS a
JOIN Grade AS g ON a.GradeId = g.Id
WHERE g.Name = "3rd Grade";

-- How many total authors are in the first through third grades?
-- 4404
SELECT COUNT(*) FROM Author AS a
JOIN Grade g ON a.GradeId = g.Id
WHERE g.Name LIKE "1st%" OR g.Name LIKE "2nd%" OR g.Name LIKE "3rd%";

-- What is the total number of poems written by fourth graders?
-- 10806
SELECT COUNT(*) FROM Poem AS p
JOIN Author AS a ON p.AuthorId = a.Id
JOIN Grade AS g ON a.GradeId = g.Id
WHERE g.Name LIKE "4th%";

-- How many poems are there per grade?
-- 1st: 886,  2nd: 3160,  3rd: 6636,  4th: 10806,  5th: 11354
SELECT COUNT(*), g.Name FROM Poem AS p
JOIN Author AS a ON p.AuthorId = a.Id
JOIN Grade AS g ON a.GradeId = g.Id
GROUP BY g.Name; 

-- How many authors are in each grade? (Order your results by grade starting with 1st Grade)
-- 1st: 623,  2nd: 1437,  3rd: 2344,  4th: 3288,  5th: 3464
SELECT COUNT(*), g.Name FROM Author AS a
JOIN Grade AS g ON a.GradeId = g.Id
GROUP BY g.Name;

-- What is the title of the poem that has the most words?
-- The Misterious Black, 263 words
SELECT Title, WordCount FROM Poem
ORDER BY WordCount DESC
LIMIT 1;

-- Which author(s) have the most poems? (Remember authors can have the same name.)
-- jessica (id 9189) with 118 poems, emily (id 8725) with 115 poems, emily (id 5388) with 98 poems, ashley (id 7996) with 94 poems, and jessica (id 5830) with 93 poems
SELECT COUNT(p.Title) AS Count, a.Name AS authorName, a.Id AS authorId FROM Poem AS p
JOIN Author AS a ON a.id = p.AuthorId
GROUP BY authorId
ORDER BY Count DESC
LIMIT 5;

-- How many poems have an emotion of sadness?
-- 14570
SELECT COUNT(p.Title) AS Count, e.Name AS Emotion FROM Poem AS p
JOIN PoemEmotion AS pe ON p.Id = pe.PoemId
JOIN Emotion AS e ON pe.EmotionId = e.Id
WHERE Emotion = "Sadness";

-- How many poems are not associated with any emotion?
-- 3368
SELECT COUNT(p.Title) AS poemCount FROM Poem AS p
LEFT JOIN PoemEmotion AS pe ON p.Id = pe.PoemId
WHERE pe.PoemId IS NULL;

-- Which emotion is associated with the least number of poems?
-- anger
SELECT e.Name AS emotionName, COUNT(p.Title) AS poemCount FROM Emotion AS e
JOIN PoemEmotion AS pe ON e.Id = pe.EmotionId
JOIN Poem AS p ON pe.PoemId = p.Id
GROUP BY emotionName
ORDER BY poemCount;

-- Which grade has the largest number of poems with an emotion of joy?
-- 5th grade, with 8928 poems about joy
SELECT COUNT(p.Title) AS poemCount, g.Name AS gradeName, e.Name AS emotionName FROM Poem AS p
JOIN Author AS a ON p.AuthorId = a.Id
JOIN Grade AS g ON a.GradeId = g.Id
JOIN PoemEmotion AS pe ON p.Id = pe.PoemId
JOIN Emotion AS e ON pe.EmotionId = e.Id
WHERE emotionName = "Joy"
GROUP BY gradeName
ORDER BY poemCount DESC
LIMIT 1;

-- Which gender has the least number of poems with an emotion of fear?
-- Ambiguous, with 1435 poems about fear
SELECT COUNT(p.Title) AS poemCount, g.Name AS genderName, e.Name AS emotionName FROM Poem AS p
JOIN Author AS a ON p.AuthorId = a.Id
JOIN Gender AS g ON a.GenderId = g.Id
JOIN PoemEmotion AS pe ON p.Id = pe.PoemId
JOIN Emotion AS e ON pe.EmotionId = e.Id
WHERE emotionName = "Fear"
GROUP BY genderName
ORDER BY poemCount
LIMIT 1;