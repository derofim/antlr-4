#include <string>
#include "antlr4-runtime.h"
#include "SceneBaseVisitor.h"
#include "SceneElems.h"

class  ImageVisitor : SceneBaseVisitor {
public:    
    antlrcpp::Any visitFile(SceneParser::FileContext *ctx);

	antlrcpp::Any visitAction(SceneParser::ActionContext *ctx);	

	antlrcpp::Any visitShape(SceneParser::ShapeContext *ctx);
};

