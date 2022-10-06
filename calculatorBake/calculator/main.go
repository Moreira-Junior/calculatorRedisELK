package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis"
	"github.com/google/uuid"
)

var (
	history []string
	ctx     = context.Background()
	redisIp = os.Getenv("REDISIP")
)

func getNum(a string, b string) (float64, float64, error) {
	num1, err := strconv.ParseFloat(a, 64)
	if err != nil {
		return 0, 0, err
	}
	num2, err := strconv.ParseFloat(b, 64)
	if err != nil {
		return 0, 0, err
	}
	return num1, num2, nil
}

func setHistory(operation string) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     redisIp + ":6379",
		Password: "",
		DB:       0,
	})
	id := uuid.New()
	err := rdb.Set(id.String(), operation, 0).Err()
	if err != nil {
		panic(err)
	}
}

func getHistory(c *gin.Context) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     redisIp + ":6379",
		Password: "",
		DB:       0,
	})
	iter := rdb.Scan(0, "*", 0).Iterator()
	var values []string
	for iter.Next() {
		val, err := rdb.Get(iter.Val()).Result()
		values = append(values, val)
		if err != nil {
			panic(err)
		}
	}
	if err := iter.Err(); err != nil {
		panic(err)
	}
	c.IndentedJSON(http.StatusOK, values)
}

func convertToString(num1 float64, num2 float64, op string, res float64) string {
	return fmt.Sprint(num1) + " " + op + " " + fmt.Sprint(num2) + " = " + fmt.Sprint(res)
}

func convertToStringInfinite(num1 float64, num2 float64, op string, res string) string {
	return fmt.Sprint(num1) + " " + op + " " + fmt.Sprint(num2) + " = " + res
}

func sum(c *gin.Context) {
	num1, num2, err := getNum(c.Param("a"), c.Param("b"))
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
	} else {
		res := num1 + num2
		history = append(history, convertToString(num1, num2, "+", res))
		setHistory(convertToString(num1, num2, "+", res))
		c.IndentedJSON(http.StatusOK, res)
	}
}

func sub(c *gin.Context) {
	num1, num2, err := getNum(c.Param("a"), c.Param("b"))
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
	} else {
		res := num1 - num2
		setHistory(convertToString(num1, num2, "-", res))
		c.IndentedJSON(http.StatusOK, res)
	}
}

func mul(c *gin.Context) {
	num1, num2, err := getNum(c.Param("a"), c.Param("b"))
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
	} else {
		res := num1 * num2
		setHistory(convertToString(num1, num2, "*", res))
		c.IndentedJSON(http.StatusOK, res)
	}
}

func div(c *gin.Context) {
	num1, num2, err := getNum(c.Param("a"), c.Param("b"))
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
	} else {
		if num2 == 0 {
			setHistory(convertToStringInfinite(num1, num2, "/", "infinite"))
			c.IndentedJSON(http.StatusOK, "infinite")
		} else {
			res := num1 / num2
			setHistory(convertToString(num1, num2, "/", res))
			c.IndentedJSON(http.StatusOK, res)
		}
	}
}

func main() {
	router := gin.Default()
	router.GET("/history", getHistory)
	router.POST("/sum/:a/:b", sum)
	router.POST("/sub/:a/:b", sub)
	router.POST("/mul/:a/:b", mul)
	router.POST("/div/:a/:b", div)
	router.Run("0.0.0.0:8080")
}
