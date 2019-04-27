package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"strings"
	"syscall"

	"github.com/bwmarrin/discordgo"
)

const TOKEN = "YOUR_TOKEN_HERE"

type messageHandler func(s *discordgo.Session, m *discordgo.MessageCreate)
type username = string

// users that get special treatment
var handlers = map[username]messageHandler{
	"god in gopher form#4334": code_handler,
	"falon#6598":              code_handler,
	"Goopsie#3132":            code_handler,
	"Embyr#4306":              code_handler,
}

// How to run different langauges
var languages = map[string][]string{
	"lua": {"lua", "-"},
	"py":  {"python", "-"},
	"hs":  {"runghc"},
	"go":  {"./gostdin"},
}

func main() {
	dg, err := discordgo.New(TOKEN)
	if err != nil {
		log.Fatal(err)
	}
	dg.AddHandler(messageCreate)

	if err := dg.Open(); err != nil {
		log.Print(err)
		return
	}

	fmt.Println("Now running. Press CTRL-C to exit.")
	sc := make(chan os.Signal, 1)
	signal.Notify(sc, syscall.SIGINT, syscall.SIGTERM, os.Interrupt, os.Kill)
	<-sc
	dg.Close()
}

func messageCreate(s *discordgo.Session, m *discordgo.MessageCreate) {
	// fmt.Printf("[%s] %s\n", m.Author, m.Content)
	u := m.Author.String()
	if handlers[u] != nil {
		handlers[u](s, m)
	}
}

// run a command from !
// Example: !ls
func run_cmd(s *discordgo.Session, m *discordgo.MessageCreate) {
	var msg strings.Builder

	cmd := m.Content[1:]
	if n := strings.Index(cmd, "\n"); n != -1 {
		cmd = cmd[:n]
	}

	b, err := exec.Command("bash", "-c", cmd).CombinedOutput()
	msg.WriteString("Output of `" + cmd + "`\n```")
	msg.Write(b)
	msg.WriteString("\n```\n")
	if err != nil {
		msg.WriteString("Error: " + err.Error())
	}

	s.ChannelMessageSend(m.ChannelID, msg.String())
}

func code_handler(s *discordgo.Session, m *discordgo.MessageCreate) {
	if strings.HasPrefix(m.Content, "!") {
		run_cmd(s, m)
	}

	// Check for code to run.
	for lang, args := range languages {
		if code := extractCode(m.Content, lang); code != "" {
			resp := &strings.Builder{}
			cmd := exec.Command(args[0], args[1:]...)

			r, w := io.Pipe()
			cmd.Stdin = r
			cmd.Stdout = resp
			cmd.Stderr = resp
			if err := cmd.Start(); err != nil {
				Errorf(s, m, "cmd.Start: %v\n", err)
				break
			}

			w.Write([]byte(code))
			if err := w.Close(); err != nil {
				Errorf(s, m, "Pipe Close: %v\n", err)
			}

			cmd.Wait()
			s.ChannelMessageSend(m.ChannelID, resp.String())
		}
	}
}

func Errorf(s *discordgo.Session, m *discordgo.MessageCreate, f string, a ...interface{}) {
	msg := fmt.Sprintf(f, a...)
	os.Stderr.WriteString("[Error] " + msg)
	s.ChannelMessageSend(m.ChannelID, msg)
}

func extractCode(s, lang string) string {
	start := strings.Index(s, "```"+lang+"\n")
	if start == -1 {
		return ""
	}
	start += 4 + len(lang)

	end := strings.LastIndex(s, "```")
	if end == -1 {
		return ""
	}

	return s[start:end]
}
