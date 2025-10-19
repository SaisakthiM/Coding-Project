import graphene
from graphene_django import DjangoObjectType
from .models import TODO

# ----------------------------- 
# 1. Define the GraphQL Type
# ----------------------------- 
class TODOType(DjangoObjectType):
    class Meta:
        model = TODO
        fields = ("id", "name", "task_description", "is_completed", "created_at", "updated_at", "due_date")

# ----------------------------- 
# 2. Define Queries
# ----------------------------- 
class Query(graphene.ObjectType):
    all_todos = graphene.List(TODOType)
    todo = graphene.Field(TODOType, id=graphene.Int(required=True))
    
    def resolve_all_todos(root, info):
        return TODO.objects.all()
    
    def resolve_todo(root, info, id):
        try:
            return TODO.objects.get(pk=id)
        except TODO.DoesNotExist:
            return None

# ----------------------------- 
# 3. Define Mutations
# ----------------------------- 
class CreateTODO(graphene.Mutation):
    todo = graphene.Field(TODOType)
    
    class Arguments:
        name = graphene.String(required=True)
        task_description = graphene.String(required=False)
        is_completed = graphene.Boolean(required=False)  # ADDED THIS
        due_date = graphene.types.datetime.Date(required=False)
    
    def mutate(self, info, name, task_description=None, is_completed=None, due_date=None):
        todo = TODO.objects.create(
            name=name,
            task_description=task_description or "",
            is_completed=is_completed if is_completed is not None else False,  # ADDED THIS
            due_date=due_date
        )
        return CreateTODO(todo=todo)

class UpdateTODO(graphene.Mutation):
    todo = graphene.Field(TODOType)
    
    class Arguments:
        id = graphene.Int(required=True)
        name = graphene.String(required=False)
        task_description = graphene.String(required=False)
        is_completed = graphene.Boolean(required=False)
        due_date = graphene.types.datetime.Date(required=False)
    
    def mutate(self, info, id, name=None, task_description=None, is_completed=None, due_date=None):
        todo = TODO.objects.get(pk=id)
        if name is not None:
            todo.name = name
        if task_description is not None:
            todo.task_description = task_description
        if is_completed is not None:
            todo.is_completed = is_completed
        if due_date is not None:
            todo.due_date = due_date
        todo.save()
        return UpdateTODO(todo=todo)

class DeleteTODO(graphene.Mutation):
    ok = graphene.Boolean()
    
    class Arguments:
        id = graphene.Int(required=True)
    
    def mutate(self, info, id):
        todo = TODO.objects.get(pk=id)
        todo.delete()
        return DeleteTODO(ok=True)

# ----------------------------- 
# 4. Combine Mutations
# ----------------------------- 
class Mutation(graphene.ObjectType):
    create_todo = CreateTODO.Field()
    update_todo = UpdateTODO.Field()
    delete_todo = DeleteTODO.Field()

# ----------------------------- 
# 5. Schema Entry Point
# ----------------------------- 
schema = graphene.Schema(query=Query, mutation=Mutation)