# rectangle merging algorithm, isolated for testing

def next_obj_horizontal(objects, base_x, base_y, grouped):
    for obj in objects:
        if obj["y"] != base_y: continue

        if obj["x"] - base_x > 1:
            return None

        if tuple(obj.items()) in grouped: continue # shouldn't need, failsafed in case
        return obj
    
    return None

def next_obj_vertical(objects, base_x, base_y, grouped):
    for obj in objects:
        # the way the objects array means if two x's are different, there is no column
        if obj["x"] > base_x: return None

        if obj["y"] - base_y > 1:
            return None
        elif tuple(obj.items()) not in grouped: # might already be part of a row
            return obj
        else:
            return None
    
    return None

def create_rect(start, end):
    if start["x"] == end["x"]:
        return {"x": start["x"], "y": start["y"], "w": 1,"h": end["y"] - start["y"] + 1}
    else:
        return {"x": start["x"], "y": start["y"], "w": end["x"] - start["x"] + 1, "h": 1}

def group_objects(objects: list):
    grouped = set()
    rects = []
    for i in range(0, len(objects)):
        obj_i = objects[i]
        
        if tuple(obj_i.items()) in grouped: continue

        # obviously alone
        if i == len(objects) - 1:
            rects.append(create_rect(obj_i, obj_i))
            break
        
        grouped.add(tuple(obj_i.items()))

        end = obj_i
        # check along horizontal axis
        while True:
            slice_start = objects.index(end)+1
            if slice_start > len(objects): break

            next_obj = next_obj_horizontal(objects[slice_start:], end["x"], end["y"], grouped)
            if not next_obj: break
            end = next_obj
            grouped.add(tuple(end.items()))

        if end != obj_i:
            rects.append(create_rect(obj_i, end))
            continue

        # check along vertical axis in case nothing found on the side
        while True:
            slice_start = objects.index(end)+1
            if slice_start > len(objects): break

            next_obj = next_obj_vertical(objects[slice_start:], end["x"], end["y"], grouped)
            if not next_obj: break
            end = next_obj
            grouped.add(tuple(end.items()))

        # append alone or with column
        rects.append(create_rect(obj_i, end))

    return rects


objects = [
    {"x": 1, "y": 2},
    {"x": 3, "y": 2},
    {"x": 4, "y": 2},
    {"x": 4, "y": 3},
    {"x": 5, "y": 2},
    {"x": 7, "y": 0},
    {"x": 7, "y": 1},
    {"x": 7, "y": 2},
    {"x": 8, "y": 0},
    {"x": 10, "y": 2},
    {"x": 12, "y": 2},
    {"x": 13, "y": 1},
    {"x": 13, "y": 2},
    {"x": 13, "y": 3},
    {"x": 14, "y": 2},
]

rects = group_objects(objects)
print(len(rects))
print(rects)