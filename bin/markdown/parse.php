<?php

define('CUR_DIR', realpath(dirname(__FILE__)));

require CUR_DIR . DIRECTORY_SEPARATOR . "lib/MarkdownLexer.php";
require CUR_DIR . DIRECTORY_SEPARATOR . "lib/MarkdownParser.php";

$file_path = $argv[1];

$content = file_get_contents($file_path);
$lexer = new MarkdownLexer($content);

$context = array(
    'file_path' => realpath($file_path)        
);

$parser = new MarkdownParser($lexer, $context);

$parser->disableDebug();
$parser->disableErrorReport();

while($lexer->yylex()){
	$parser->doParse($lexer->token, $lexer->value);
}
$parser->doParse(0, '');

if($parser->successful){

    echo( 
        "insert into t_markdown_articles (title, tag, author, time, content) values (" 
        . "\"" . str_escape($context[0]['content']) . "\","
        . "\"" . str_escape($context[3]['content']) . "\","
        . "\"" . str_escape($context[1]['content']) . "\","
        . "current_timestamp(),"
        . json_encode(json_encode(
            array('content' => simplify($context))
        )) 
        . ");"
    );

}
else{
    echo "parse error \n";
}

function str_escape($str){
    return preg_replace('/"|\\\\/', '\\\\$0', $str);
}

function simplify($context){
    $doc = array();
    $cur_type = null;
    $conf_mergable_types = array(
        'docinfo'
        ,'ul'
        ,'ol'
        ,'code'
    );
    $conf_skipwhenempty_types = array(
        'docinfo'
        ,'ul'
        ,'ol'
        ,'paragraph'
        ,'headline'
    );

    foreach($context as $key => $value){
        $type = $value['type'];
        $arr_len = count($doc);

        // 略过空内容块
        if(in_array($type, $conf_skipwhenempty_types) 
            && empty($value['content'])){
            continue;
        }

        if(in_array($type, $conf_mergable_types)){
            if($type == $cur_type){
                array_push($doc[$arr_len - 1]['content'], $value['content']); 
            }
            else{
                $cur_type = $type;
                $tmp = array(
                    'type' => $type
                    ,'content' => array($value['content'])
                );
                array_push($doc, $tmp);
            }
        }
        else{
            $cur_type = $type;
            array_push($doc, $value);
        }
    }

    return $doc;

}

