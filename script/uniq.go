package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"os"
	"strings"
)

func check(str string, dic map[string]int) {
	fmt.Println(str)
}

func ReadLine2(fileName string, dic map[string]int, handler func(string, map[string]int)) error {
	f, err := os.Open(fileName)
	defer f.Close()
	if err != nil {
		return err
	}
	buf := bufio.NewReader(f)
	for {
		line, err := buf.ReadString('\n')
		line = strings.TrimSpace(line)
		handler(line, dic)
		if err != nil {
			if err == io.EOF {
				return nil
			}
			return err
		}
	}
	return nil
}
func ReadLine(fileName string, dic map[string]int, handler func(string, map[string]int)) error {
	f, err := os.Open(fileName)
	defer f.Close()
	if err != nil {
		return err
	}
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := scanner.Text()
		line = strings.TrimSpace(line)

		handler(line, dic)
		err := scanner.Err()
		if err != nil {
			if err == io.EOF {
				return nil
			}
			return err
		}
	}

	return nil
}

func GenList(str string, dic map[string]int) {
	dic[str] = 0

}

func main() {
	flag.Parse()
	file1 := flag.Arg(0)
	file2 := flag.Arg(1)

	list1 := make(map[string]int)
	list2 := make(map[string]int)

	ReadLine(file1, list1, GenList)
	ReadLine(file2, list2, GenList)

	for k, v := range list1 {
		if v == 1 {
			fmt.Println("dup in list1, Continue...", k, v)
			continue
		}

		for k1, v1 := range list2 {
			if v1 == 1 {
				//fmt.Println("dup in list2, Continue...")
				continue
			} else if k1 == k {
				fmt.Println("found new dup , break...", k, v, "==", k1, v1)
				list1[k] = 1
				list2[k1] = 1
				break
			}
		}
	}

	fmt.Println("======== uniq in list1 ========")
	for k, v := range list1 {
		if v == 0 {
			fmt.Printf("%s\n", k)
		}

	}
}
