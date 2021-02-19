/*1. The poetry in this database is the work of children in grades 1 through 5.
a. How many poets from each grade are represented in the data?
b. How many of the poets in each grade are Male and how many are Female? Only return the poets identified as Male or Female.
c. Do you notice any trends across all grades?*/ 11156_authors 

Select Count(a.id) AS number_authors, g.name as grade
From author AS a 
LEFT JOIN grade as g on a.grade_id = g.id
Group BY grade
Order BY grade

--Question 1a.
--623	"1st Grade"
--1437	"2nd Grade"
--2344	"3rd Grade"
--3288	"4th Grade"
--3464	"5th Grade"

Select Count(a.id) AS number_authors, g.name as grade, gen.name
From author AS a 
LEFT JOIN grade as g on a.grade_id = g.id
Left JOIN gender AS gen ON a.gender_id = gen.id
Where gen.name = 'Male'
OR gen.name = 'Female'
Group BY grade, gen.name
Order BY gen.name, grade;
-- Question1b. There are more males than females across all grades 


--Question 2 Love and death have been popular themes in poetry throughout time.
--Which of these things do children write about more often? Which do they have the most to say about when they do? 
--Return the total number of poems, their average character count for poems that mention death and poems that 
--mention love. Do this in a single query.

Select Count(title) as number_poems_about_death, ROUND(AVG(char_count),2)
From poem
Where text ILIKE'%death%'
--86 about death 342.53 avg words per poem

Select COUNT(title) as number_of_poem_about_love, Round(AVG(char_count),2)  
From poem
Where text ILIKE '%love%'
--4464 about love 226.79 avg words per poem


/*Q3. Do longer poems have more emotional intensity compared to shorter poems?
a. Start by writing a query to return each emotion in the database with it's average intensity and character count.
Which emotion is associated the longest poems on average?
Which emotion has the shortest?*/
Select e.name, ROUND(Avg(intensity_percent),2) as avg_intensity_percent, ROUND(AVG(char_count),2)as avg_number_words
From author as a 
Left Join poem as p on a.id=p.author_id 
Left Join poem_emotion as pe on p.id= pe.poem_id 
Left Join emotion as e on pe.emotion_id = e.id
Where e.name is not null 
and intensity_percent is not null
Group by e.name
Order by avg(char_count)desc
-- Joy had the highest avg_intensity with a avg word count of 220.99 and Anger had an avg_intensity of 43.57 but the
--longest avg word count of 261.16. This shows that the highest intensity poems don't have to be the longest 

/*b. Convert the query you wrote in part a into a CTE. Then find the 5 most intense poems that express joy and whether they are to be longer or shorter than the average joy poem.
What is the most joyful poem about?
Do you think these are all classified correctly?*/

with emotion_avg as (Select e.name as emotion, intensity_percent as intensity, char_count as char_count, title, text as content
					From author as a 
					Left Join poem as p on a.id=p.author_id 
					Left Join poem_emotion as pe on p.id= pe.poem_id 
					Left Join emotion as e on pe.emotion_id = e.id
					Where e.name is not null 
					and intensity_percent is not null)
Select intensity, emotion, char_count, title, content
From emotion_avg
Where emotion ='Joy'
Order by intensity desc
Limit 5;

-- For myself the poem Happiness was my favorite in terms of being the most happy and the poem dark is defintely in the wrong category

 
--Question 4. Compare the 5 most angry poems by 1st graders to the 5 most angry poems by 5th graders.
--a. Which group writes the angreist poems according to the intensity score? 4th graders 
Select title, e.name, pe.intensity_percent, g.name, gen.name as gender  
FROM author AS a 
LEFT JOIN gender as gen on a.gender_id = gen.id
LEFT JOIN grade AS g ON g.id = a.grade_id
Left JOIN poem as p ON a.id = p.author_id
LEFT JOIN poem_emotion as pe on pe.poem_id = p.id
LEFT JOIN emotion as e on e.id = pe.emotion_id
Where e.name = 'Anger'
and g.name = '5th Grade'
Order by intensity_percent DESC
Limit 5 

Select title, e.name, pe.intensity_percent, g.name, gen.name as gender  
FROM author AS a 
LEFT JOIN gender as gen on a.gender_id = gen.id
LEFT JOIN grade AS g ON g.id = a.grade_id
Left JOIN poem as p ON a.id = p.author_id
LEFT JOIN poem_emotion as pe on pe.poem_id = p.id
LEFT JOIN emotion as e on e.id = pe.emotion_id
Where e.name = 'Anger'
and g.name = '1st Grade'
Order by intensity_percent DESC
Limit 5 
--b.Who shows up more in the top five for grades 1 and 5, males or females? In both grades the females show up more than males



--Question 5
SELECT a.name, g.name as grade, title, e.name as poem_emotion  
FROM author AS a 
LEFT JOIN grade AS g ON g.id = a.grade_id
Left JOIN poem as p ON a.id = p.author_id
WHERE a.name ILIKE '%Emily%'



