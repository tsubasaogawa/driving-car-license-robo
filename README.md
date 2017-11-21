# driving car license robo

Question solver about driving a car

## environment

+ Heroku + Ruby 1.9 + Rails 3

## flow

1. Input driving question.

2. The robo splits the sentence into morphemes using Yahoo! morphological API.

3. The morphemes are converted to features with bag-of-words.

4. The obtained features are used for SVM: support vector machines.

    + Dataset was created by using over 1,000 questions.

5. Judgments.

## special thanks

http://menkyo-web.com/

