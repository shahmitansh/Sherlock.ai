Watson has a new friend. Sherlock.ai: "Interviews can be challenging. Preparing for them shouldn't have to be."

# Sherlock.ai
## The Game is On.

## Inspiration
It’s a well-known truth that interview preparation is often a shot in the dark. You prepare for certain lines of questioning before the interview and leave flummoxed by the time you’re done. We set out to resolve this enigma by quantitatively analyzing what companies are really looking for when you walk through that door.

## What it does
The app asks the user a number of questions that the specific company often has asked interviewees in the past. Users then record audio responses to those questions. The responses, along with scraped data from the company’s website, are sent to Watson for Tone Analysis which delivers linguistic, social, and emotional analysis on data processed. Through data visualization, the user is able to see how his answers stack up against what the company is looking for on a number of characteristics using spider charts. The user then has a quantitative understanding of how he needs to change his answers to succeed.

## How we built it
We used Swift to build our iOS application, as well as to interact with Watson on Bluemix and the iOS Charts API. The application uses iOS’s native speech recognition to convert the speech input to text. We then used Watson’s iOS SDK to interact with the Bluemix API to send requests to the system. After parsing the JSON output from Watson, we displayed that data on spider charts.

## What's next for Sherlock
As a further development, we would love to crowd-source answers from successful applicants to specific companies and then use machine learning so that Sherlock also has a native understanding of what kind of things a company looks for in interviews as opposed to data scraping being the only source of data for the app. We are keen on expanding on Sherlock beyond this event so that it can become a powerful tool for the community.

##Installation
All of the project files are available in the repository. In some cases, the pods used for the iOS Charts API may not install correctly. In this case, please follow the instructions at the GitHub repository of the API used at https://github.com/danielgindi/Charts

##Contributing Members
Mitansh Shah, Suyash Saxena, Ashwin Vivek, Taasin Saquib, Brian Shih
