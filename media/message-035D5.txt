//import os
//import sys
use std::env;
use std::fs::File;
use std::io::{Read, Write};

fn main() {
    //os.chdir("/inkbox/book/split")
    env::set_current_dir("/inkbox/book/split/").unwrap();

    //book = open("../book.txt", "r")
    let mut book = File::open("/inkbox/book/book.txt").unwrap();

    //text = book.read()
    let mut text: String = String::new();
    book.read_to_string(&mut text);

    // book.close()
    drop(book);

    //booklist = text.split(" ")
    let booklist = text.split(" ");

    //words_number = sys.argv[1]
    let args: Vec<String> = env::args().collect();
    let words_number = &args[1];

    //words_number_int = int(words_number)
    let words_number_int: i32 = words_number.parse().unwrap();

    // split_booklist = [booklist[x:x+words_number_int] for x in range(0, len(booklist),words_number_int)]

    let mut split_booklist: Vec<Vec<String>> = Vec::new();
    let mut count = 0;
    let mut one_file: Vec<String> = Vec::new();
    for word in booklist {
        count += 1;
        one_file.push(word.to_string());
        if count == words_number_int {
            count = 0;
            split_booklist.push(one_file);
            one_file = Vec::new();
        }
    }

    //println!("{:?}", split_booklist);

    let mut count_file_name = 0;
    for one_file_string in split_booklist {
        let mut purged_vec: String = String::new();

        for string in one_file_string {
            println!("1 |{:?}|", string);

            let mut new_string: String = string;

            //let abc = vec![
            //    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
            //    "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "ą", "ć", "ę", "ł", "ń", "ó",
            //    "ś", "ź", "ż", ",",
            //];
            /*
            for letter in abc {
                new_string = new_string.replace(
                    &(letter.to_string() + &"\n".to_string()),
                    &(letter.to_string() + &" "),
                );
                new_string = new_string.replace(
                    &(letter.to_string().to_uppercase() + &"\n".to_string()),
                    &(letter.to_string().to_uppercase() + &" "),
                );
            }
            */
            if new_string.is_empty() {
                continue;
            }
            if new_string.contains("\r\n\r\n\r\n\r\n") == false {
                if new_string.contains(".\r\n") == true {
                    // Don't ....... touch it
                    if new_string.matches(".").count() == 1 {
                        let mut many = false;
                        if new_string.contains(".\r\n\r\n") == true {
                            many = true;
                        } else {
                            while new_string.contains("\r\n\r\n") == true {
                                new_string = new_string.replace("\r\n\r\n", " ");
                            }
                        }
                        while new_string.contains("\r\n") == true {
                            new_string = new_string.replace("\r\n", " ");
                        }

                        let mut string_replacement = "";
                        if many == true {
                            string_replacement = ".\r\n\r\n";
                        } else {
                            string_replacement = ".\r\n";
                        }
                        for num in 0..20 {
                            new_string = new_string.replace(". ", ".");
                        }
                        new_string = new_string.replace(".", string_replacement);
                    }
                } else {
                    //if new_string.contains("\r\n\r\n") == false {
                    if new_string.contains("\r\n") == true {
                        if new_string.contains("\r\n\r\n") == false {
                            while new_string.contains("\r\n") == true {
                                new_string = new_string.replace("\r\n", " ");
                            }
                        } else {
                            if new_string.contains(".") == true {
                                new_string = new_string.replace("\r\n\r\n", "!@#$%^&*(((");
                                while new_string.contains("\r\n") == true {
                                    new_string = new_string.replace("\r\n", " ");
                                }
                                new_string = new_string.replace("!@#$%^&*(((", "\r\n\r\n");
                            }
                        }
                    }
                    //}
                }
            } else {
                new_string = new_string.replace("\r\n\r\n\r\n\r\n", "\r\n\r\n");
            }

            /*
            if new_string.contains(".\r\n") == false {
                new_string = new_string.replace("\r\n", " ");

            }
            */

            println!("2 |{:?}|", new_string);
            new_string = new_string.replace("  ", " ");

            purged_vec.push_str(&new_string);

            /*if !new_string.contains("\n") {
                purged_vec.push_str(" ");
            } else {
                println!("WTF \"{}\"", new_string);
            }*/

            purged_vec.push_str(" ");
        }

        let mut new_file = File::create(count_file_name.to_string()).unwrap();

        new_file.write_all(purged_vec.as_bytes()).unwrap();
        count_file_name += 1;
    }
}
