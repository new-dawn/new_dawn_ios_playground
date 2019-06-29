//
//  QuestionAnswer.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/6/29.
//  Copyright © 2019 New Dawn. All rights reserved.
//

// Question and answer structures

let SAMPLE_QUESTIONS = [
    Question(id: 1, question: "关于我"),
    Question(id: 2, question: "最完美的周末"),
    Question(id: 3, question: "我的理想型"),
    Question(id: 4, question: "至今最大的成就感"),
    Question(id: 5, question: "当我去吃火锅时，一定会点的三样菜"),
    Question(id: 6, question: "如果可以出演一部电影，我想演"),
    Question(id: 7, question: "KTV最拿手的歌"),
    Question(id: 8, question: "我最喜欢的一句歌词"),
    Question(id: 9, question: "最冒险的一次人生经历"),
    Question(id: 10, question: "儿时的梦想"),
    Question(id: 11, question: "生命中对我影响最深的人"),
    Question(id: 12, question: "2句真话，1句假话"),
    Question(id: 13, question: "我的特别技能"),
    Question(id: 14, question: "我最后的一餐会是"),
    Question(id: 15, question: "你应该回复我，如果你"),
    Question(id: 16, question: "我再也不会做的一件事"),
    Question(id: 17, question: "上一次我哭是"),
    Question(id: 17, question: "最好得到我心的办法"),
    Question(id: 18, question: "我们会相处的很好，如果"),
    Question(id: 19, question: "你会知道我喜欢你，如果"),
    Question(id: 20, question: "让我开心的办法是"),
    Question(id: 21, question: "我的人生目标是"),
    Question(id: 22, question: "如果我有一亿元，我会"),
    Question(id: 23, question: "最近我在"),
    Question(id: 23, question: "第一次约会，我想"),
    Question(id: 24, question: "我想知道你"),
]

struct Question: Codable {
    var id: Int
    var question: String
    init() {
        self.id = 0
        self.question = UNKNOWN
    }
    init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
}

struct QuestionAnswer: Codable {
    var id: Int
    var question: Question
    var answer: String
    init() {
        self.id = 0
        self.question = Question()
        self.answer = UNKNOWN
    }
    init(id: Int, question: Question, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}
