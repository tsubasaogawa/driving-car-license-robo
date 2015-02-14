# driving car license robo

He may solve questions about driving a car.

## environment

+ Heroku + Ruby 1.9 + Rails 3

## flow

1. An user can input a driving question.

2. The system splits the sentence into morphemes using Yahoo! morphological API.

3. The morphemes are converted to features with bag-of-words.

4. The obtained features are used for SVM: support vector machines.

    + A dataset was created by using over 1,000 questions.

5. The system judgments finally.

## used gem

+ yahoo_parse_api

+ json

+ libsvm-ruby-swig

+ nokogiri (for scraping)

## thanks

http://menkyo-web.com/

## contact

Author: Tsubasa Ogawa (hurikaketown@hotmail)

